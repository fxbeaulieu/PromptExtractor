# OS Support
* Written and tested on Windows 11
  * Should also work on Win 10 out of the box
  * Could easily be adapted for UNIX-based OS
    * Maybe a future update !? 🎧

# Requirements
* Python 3.11 installed

# How to run
1. Clone the repo and move files to a directory named "PromptExtractor" inside your user profile folder
   * The path containing the files from the repo should be something like --> C:\Users\YourUsername\PromptExtractor
2. Open a PowerShell window (versions 7.X if possible instead of Windows PowerShell)
3. Copy your Stable Diffusion generated pictures from which you want to extract the prompts in a directory named "pic_src" inside your Pictures folder
   * The path containing the pictures to analyze should be something like this --> C:\Users\YourUsername\Pictures\pic_src
3. Navigate to the PromptExtractor directory
5. Run the command below
   * <code>Unblock-File -Path .\Start-Refresh.ps1; Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process; .\Start-Refresh.ps1</code>
