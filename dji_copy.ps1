Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Size = New-Object System.Drawing.Size(500,200)
$form.Text = "Copy Files"

$label = New-Object System.Windows.Forms.Label
$label.Location = New-Object System.Drawing.Point(30,20)
$label.Size = New-Object System.Drawing.Size(200,20)
$label.Text = "Destination Directory Name:"
$form.Controls.Add($label)

$textBox = New-Object System.Windows.Forms.TextBox
$textBox.Location = New-Object System.Drawing.Point(30,50)
$textBox.Size = New-Object System.Drawing.Size(400,20)
$form.Controls.Add($textBox)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(30,90)
$progressBar.Size = New-Object System.Drawing.Size(400,20)
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$form.Controls.Add($progressBar)

$button = New-Object System.Windows.Forms.Button
$button.Location = New-Object System.Drawing.Point(175,120)
$button.Size = New-Object System.Drawing.Size(75,23)
$button.Text = "Copy"
$button.Add_Click({
    $destinationDirectory = "F:\Pictures\" + (Get-Date -Format "yyyy-MM-dd") + "_" + $textBox.Text
    If ($textBox.Text -ne "") {
        If (Test-Path $destinationDirectory) {
            Remove-Item -Path $destinationDirectory -Recurse
        }
        New-Item -ItemType Directory -Path $destinationDirectory

        $files = Get-ChildItem "J:\" -File -Recurse
        $count = $files.Count
        $index = 0

        ForEach ($file in $files) {
            $progressBar.Value = [int](($index / $count) * 100)
            $form.Refresh()
            Copy-Item $file.FullName -Destination $destinationDirectory
            $index++
        }
        $progressBar.Value = 100
        $form.Close()
    }
})
$form.Controls.Add($button)

$form.ShowDialog()
