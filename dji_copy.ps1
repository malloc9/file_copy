Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(400,250)
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen
$form.Text = "Copy files from J drive"

$label1 = New-Object System.Windows.Forms.Label
$label1.Size = New-Object System.Drawing.Size(70, 20)
$label1.Location = New-Object System.Drawing.Point(30, 30)
$label1.Text = "Destination:"

$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Size = New-Object System.Drawing.Size(200, 20)
$textbox.Location = New-Object System.Drawing.Point(100, 30)

$copyButton = New-Object System.Windows.Forms.Button
$copyButton.Size = New-Object System.Drawing.Size(80,20)
$copyButton.Location = New-Object System.Drawing.Point(150, 60)
$copyButton.Text = "Copy"
$copyButton.Add_Click({
    if ($textbox.Text -eq "") {
        [System.Windows.Forms.MessageBox]::Show("Please enter destination name", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    } else {
        $destination = "F:\Pictures\$((Get-Date).ToString('yyyy-MM-dd'))_$($textbox.Text)"
        if (!(Test-Path $destination)) {
            New-Item -ItemType Directory -Path $destination
        }
        $files = Get-ChildItem "J:\" -File -Recurse
        $progressBar = New-Object System.Windows.Forms.ProgressBar
        $progressBar.Size = New-Object System.Drawing.Size(200,20)
        $progressBar.Location = New-Object System.Drawing.Point(100, 100)
        $progressBar.Minimum = 0
        $progressBar.Maximum = $files.Count
        $form.Controls.Add($progressBar)
        $counter = 0
        foreach ($file in $files) {
            $counter++
            $progressBar.Value = $counter
            $destinationFile = Join-Path $destination $file.Name
            Copy-Item $file.FullName $destinationFile
        }
        [System.Windows.Forms.MessageBox]::Show("Files copied successfully", "Info", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
})

$form.Controls.Add($label1)
$form.Controls.Add($textbox)
$form.Controls.Add($copyButton)
$form.ShowDialog()
