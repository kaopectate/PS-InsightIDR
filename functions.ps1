Function Get-IdrInvestigations {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [String]
        $apikey
    )
    $headers = @{
        'X-Api-Key' = "$apikey"
        'Content-Type' = 'application/json'
    }
    $body = @{
        'statuses' = 'OPEN'
        'size' = '1000'
    }
    $gets = (Invoke-RestMethod -Method Get -Uri https://us.api.insight.rapid7.com/idr/v1/investigations -Headers $headers -Body $body).data
    foreach($get in $gets){
        $props = [ordered]@{   
            'id' = $get.id;     
            'title' = $get.title;
            'status' = $get.status;
            'source' = $get.source;
            'alerts' = $get.alerts;
            'created_time' = $get.created_time}
        $obj = New-Object -TypeName psobject -Property $props
        Write-Output $obj
    }
    Start-Sleep -Milliseconds 200
}

Function Assign-IdrInvestigation{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [string]
        $apikey,
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)]
        [string]
        $email,
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]
        $id
    )
    $headers = @{
        'X-Api-Key' = "$apikey"
        'Content-Type' = 'application/json'
    }
    $body = @{'user_email_address' = "$email"} | ConvertTo-Json
    ForEach-Object{
        Invoke-RestMethod -Method Put -Uri "https://us.api.insight.rapid7.com/idr/v1/investigations/$id/assignee" -Headers $headers -Body $body
        Start-Sleep -Milliseconds 200
    }

}

function Close-IdrInvestigation {
[CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [string]
        $apikey,    
        [Parameter(Mandatory=$true,ValueFromPipeline=$true)]
        [String]
        $id
    )
    $headers = @{
        'X-Api-Key' = "$apikey"
        'Content-Type' = 'application/json'
    }
    Invoke-RestMethod -Method Put -Uri "https://us.api.insight.rapid7.com/idr/v1/investigations/$id/status/CLOSED" -Headers $headers
    Start-Sleep -Milliseconds 200
}
