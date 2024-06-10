
import os
from pathlib import Path
from dotenv import load_dotenv


CWD = os.path.dirname(os.path.realpath(__file__))

dotenv_path = Path(os.path.join(CWD, ".env"))
load_dotenv(dotenv_path=dotenv_path)


def get_workspace_path():
    workspace = os.getenv("WORKSPACE", "$HOME")

    if os.name == 'posix':  # Unix-like environment (Linux, macOS, etc.)
        workspace = os.path.expandvars(workspace)
    elif os.name == 'nt':   # Windows environment
        workspace = os.path.expandvars(
            workspace.replace('$HOME', '%USERPROFILE%'))
    return workspace
