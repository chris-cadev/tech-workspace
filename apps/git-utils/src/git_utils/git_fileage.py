import subprocess
from datetime import datetime, timezone
import click

created_date_string_format = "%Y-%m-%d %H:%M:%S%z"

@click.command()
@click.argument('file_path')
@click.option('--repo-path', default='.', help='Path to the Git repository (default: current directory)')
def calculate_file_age(file_path, repo_path):
    created_str = get_file_creation_date(file_path, repo_path)

    if created_str:
        created_datetime = datetime.strptime(str(created_str), created_date_string_format)
        formatted_age, human_readable_age = calculate_age(created_datetime)
        click.echo(f"created: {formatted_age}")
        click.echo(f"time-passed: {human_readable_age}")
    else:
        click.echo("Error: Unable to determine file creation date.")


def get_file_creation_date(file_path, repo_path='.'):
    try:
        command = f"git -C {repo_path} log --format=%aI --reverse {file_path}"
        result = subprocess.run(command.split(), cwd=repo_path, capture_output=True, text=True)
        output = result.stdout.strip()

        commit_date = output.splitlines()[0]
        return datetime.fromisoformat(commit_date)
    except Exception as e:
        click.echo(f"Error: {e}")
        return None


def calculate_age(created_date):
    current_date = datetime.now(timezone.utc)
    age = current_date - created_date

    formatted_age = current_date.strftime('%Y-%m-%d')

    years = age.days // 365
    months = (age.days % 365) // 30
    days = (age.days % 365) % 30
    hours, remainder = divmod(age.seconds, 3600)
    minutes, seconds = divmod(remainder, 60)
    human_readable_age = f"{years}y {months}m {days}d {hours}h {minutes}m {seconds}s"

    return formatted_age, human_readable_age


if __name__ == '__main__':
    calculate_file_age()
