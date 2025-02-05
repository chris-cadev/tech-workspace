import subprocess
from datetime import datetime, timezone
import click
import tzlocal

created_date_string_format = "%Y-%m-%d %H:%M:%S%z"

@click.command()
@click.argument('file_path')
@click.option('--repo-path', default='.', help='Path to the Git repository (default: current directory)')
def calculate_file_age(file_path, repo_path):
    created_str = get_file_creation_date(file_path, repo_path)

    if created_str:
        created_datetime = datetime.strptime(str(created_str), created_date_string_format)
        today_date, created_date, human_readable_age, local_today, local_created, local_zone = calculate_age(created_datetime)
        click.echo(f"  today: {today_date} UTC [{local_today} {local_zone}]")
        click.echo(f"created: {created_date} UTC [{local_created} {local_zone}]")
        click.echo(f"elapsed: {human_readable_age}")
    else:
        click.echo("Error: Unable to determine file creation date.")


def get_file_creation_date(file_path, repo_path='.'):
    try:
        command = f"git -C {repo_path} log --diff-filter=A --format=%aI -- {file_path}"
        result = subprocess.run(command.split(), cwd=repo_path, capture_output=True, text=True)
        output = result.stdout.strip()

        if not output:
            return None  # File might not be tracked by Git

        return datetime.fromisoformat(output)
    except Exception as e:
        print(f"Error: {e}")
        return None

DATE_FORMAT = '%Y-%m-%d %H:%M'

def calculate_age(created_date):
    current_date = datetime.now(timezone.utc)
    age = current_date - created_date

    created_date_formatted = created_date.strftime(DATE_FORMAT)
    today_date_formatted = current_date.strftime(DATE_FORMAT)

    # Get system's local timezone
    local_tz = tzlocal.get_localzone()

    # Convert UTC times to local timezone
    local_created = created_date.astimezone(local_tz).strftime(DATE_FORMAT)
    local_today = current_date.astimezone(local_tz).strftime(DATE_FORMAT)
    local_zone = str(local_tz)  # Use str() to get the timezone name

    # Calculate human-readable age
    years = age.days // 365
    months = (age.days % 365) // 30
    days = (age.days % 365) % 30
    hours, remainder = divmod(age.seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    human_readable_age = f"{years}y {months}m {days}d {hours}h {minutes}m {seconds}s"

    return today_date_formatted, created_date_formatted, human_readable_age, local_today, local_created, local_zone


if __name__ == '__main__':
    calculate_file_age()
