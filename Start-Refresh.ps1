# Function to setup the environment if it's not already setup
function Set-Env {
    $setupDonePath = ".\setup_done.info"
    $pythonPath = ".\venv\Scripts\python.exe"

    # Check if the setup has already been done
    if(!(Test-Path -Path $setupDonePath)) {
        # Check if Python is installed
        if(!(Get-Command python -ErrorAction Stop)) {
            Write-Error "Python is not installed on this system. Please install Python and try again."
            exit 1
        }

        # Check if Python virtual environment is created, if not, create it
        if(!(Test-Path -Path $pythonPath)) {
            &python -m venv venv
            if($LASTEXITCODE -ne 0) {
                Write-Error "Failed to create Python virtual environment"
                exit 1
            }
        }
        
        # Install the required packages
        $requirementsPath = "./requirements.txt"  # Corrected path
        &.\venv\Scripts\python.exe -m pip install -r $requirementsPath
        if($LASTEXITCODE -ne 0) {
            Write-Error "Failed to install Python packages"
            exit 1
        }

        # Create a file to indicate that the setup has been done
        New-Item -Path . -Name setup_done.info -ItemType File -Force
    }
}

# Function to refresh the environment
function Start-Refresh {
    $base_path = "$ENV:USERPROFILE\PromptExtractor"
    $base_data_path = "$base_path\data"
    $images_base_path = "$base_data_path\pics"
    $prompt_html_path = "$base_data_path\prompts_history_data.html"
    $prompt_only_datalist = "$base_data_path\prompts_history_data.txt"
    $images_source_path = "$ENV:USERPROFILE\Pictures\pic_src"

    # Create the necessary directories
    New-Item -Path $base_data_path -ItemType Directory -Force

    # Remove the old images and create a new directory for the new ones
    Remove-Item -Path $images_base_path -Force -ErrorAction SilentlyContinue
    New-Item -Path $images_base_path -ItemType Directory -Force

    # Remove the old HTML file
    Remove-Item -Path $prompt_html_path -Force -ErrorAction SilentlyContinue

    # Remove the old prompts
    Remove-Item -Path $prompt_only_datalist -Force -ErrorAction SilentlyContinue

    # Copy the images from the source to the destination directory
    Get-ChildItem -Path $images_source_path -File -Include *.png,*.PNG,*.jpg,*.jpeg,*.JPG,*.JPEG -Recurse | Copy-Item -Destination $images_base_path

    # Run the Python script
    &.\venv\Scripts\python.exe .\prompt_extractor.py
    if($LASTEXITCODE -ne 0) {
        Write-Error "Failed to run Python script"
        exit 1
    }

    # Open the HTML file in Microsoft Edge
    &'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' $prompt_html_path
}

# Function to start the execution
function Start-Exec {
    $setupDonePath = ".\setup_done.info"
    
    # Check if the setup has been done, if not, do it
    if(Test-Path -Path $setupDonePath) {
        Start-Refresh
    }
    else {
        Set-Env
        if($?) {
            Start-Refresh
        }
        else {
            exit 1
        }
    }
}

# Set the location to the script's root directory and start the execution
Set-Location "$PSScriptRoot"
Start-Exec