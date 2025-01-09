import os
import re
import pandas as pd
import click
import hashlib
import logging


def setup_logging(verbosity):
    """Set up logging based on verbosity level."""
    levels = {0: logging.WARNING, 1: logging.INFO,
              2: logging.DEBUG, 3: logging.NOTSET}
    level = levels.get(verbosity, logging.NOTSET)
    logging.basicConfig(
        format='%(asctime)s - %(levelname)s - %(message)s',
        level=level,
        datefmt='%Y-%m-%d %H:%M:%S'
    )
    logging.info("Logging configured with verbosity level %d", verbosity)


def calculate_hash(file_path):
    """Calculate SHA256 hash of a file."""
    sha256 = hashlib.sha256()
    with open(file_path, 'rb') as f:
        while chunk := f.read(8192):
            sha256.update(chunk)
    logging.debug("Hash calculated for %s: %s", file_path, sha256.hexdigest())
    return sha256.hexdigest()


def extract_date_from_filename(filename):
    """
    Extract date (YYYY-MM) from filename following the pattern:
    ingresosDeEfectivo_<MONTH>_<YEAR>.xls
    """
    month_map = {
        "ENERO": "01", "FEBRERO": "02", "MARZO": "03", "ABRIL": "04",
        "MAYO": "05", "JUNIO": "06", "JULIO": "07", "AGOSTO": "08",
        "SEPTIEMBRE": "09", "OCTUBRE": "10", "NOVIEMBRE": "11", "DICIEMBRE": "12"
    }
    # Skip renaming if the file already starts with a prefix in YYYY-MM_
    if re.match(r"^\d{4}-\d{2}_", filename):
        logging.debug("File already has a date prefix: %s", filename)
        return None

    match = re.match(r"ingresosDeEfectivo_([A-Z]+)_(\d{4})\.xls", filename)
    if match:
        month, year = match.groups()
        if month in month_map:
            return f"{year}-{month_map[month]}"
    return None


def rename_file(file_path, folder_path, date_prefix):
    """Rename the file with the date prefix (YYYY-MM) if provided."""
    filename = os.path.basename(file_path)
    new_filename = f"{date_prefix}_{filename}"
    new_path = os.path.join(folder_path, new_filename)
    os.rename(file_path, new_path)
    logging.info("File renamed to: %s", new_filename)
    return new_path


def process_file(file_path, hashes_processed):
    """
    Process an Excel file, check for duplicates, and return total income.
    """
    logging.info("Processing file: %s", file_path)

    file_hash = calculate_hash(file_path)

    if file_hash in hashes_processed:
        logging.info("Duplicate file detected and ignored: %s", file_path)
        return 0, file_hash, True  # Return 0 income and mark as duplicate

    try:
        # Read the Excel file using xlrd engine
        df = pd.read_excel(file_path, header=None, engine='xlrd')
        income_column = df.columns[-1]  # Assume income is in the last column

        # Convert income column to numeric, replacing errors with 0
        df[income_column] = pd.to_numeric(
            df[income_column], errors='coerce').fillna(0)

        # Sum the income values
        total_income = df[income_column].sum()
        logging.debug("Income detected in %s: %s", file_path, total_income)
    except Exception as e:
        logging.error("Error processing %s: %s", file_path, str(e))
        raise RuntimeError(f"Error processing {file_path}: {str(e)}")

    return total_income, file_hash, False


@click.command()
@click.argument('folder_path', type=click.Path(exists=True, file_okay=False, dir_okay=True, readable=True))
@click.option('-v', '--verbose', count=True, help="Increase verbosity level (up to -vvv for trace logs).")
@click.option('--show-files', is_flag=True, help="Show processed files including ignored duplicates.")
@click.option('--rename', is_flag=True, help="Rename files with a date prefix (YYYY-MM).")
def calculate_total_income(folder_path, verbose, show_files, rename):
    """
    Calculate total income by summing values from .xls files in the given folder,
    avoiding duplicate files based on content.

    If --rename is used, files will be renamed with a date prefix (YYYY-MM) to allow sorting by name.
    """
    setup_logging(verbose)
    total_income = 0
    processed_files_count = 0
    hashes_processed = set()

    logging.info("Starting processing for folder: %s", folder_path)

    for filename in sorted(os.listdir(folder_path)):
        if filename.endswith(".xls"):
            file_path = os.path.join(folder_path, filename)

            # Extract date and rename if --rename flag is set
            date_prefix = extract_date_from_filename(filename)
            if rename and date_prefix:
                file_path = rename_file(file_path, folder_path, date_prefix)
                filename = os.path.basename(file_path)

            try:
                income, file_hash, is_duplicate = process_file(
                    file_path, hashes_processed)
                if is_duplicate:
                    if show_files:
                        click.echo(f"Duplicate ignored: {filename}")
                    continue

                total_income += income
                hashes_processed.add(file_hash)
                processed_files_count += 1

                if show_files:
                    click.echo(f"Processed: {filename}")

                logging.info("File processed successfully: %s", filename)

            except RuntimeError as e:
                click.echo(str(e), err=True)

    click.echo(f"Processed files: {processed_files_count}")
    click.echo(f"Total income: {total_income}")
    logging.info("Processing completed. Processed files: %d, Total income: %s",
                 processed_files_count, total_income)


if __name__ == '__main__':
    calculate_total_income()
