#######################################
#
# Powershell script to create an import file for Terminals
# https://terminals.codeplex.com/
#
# Script created by: Niels van de Coevering
# Date: 05/31/2014
#
#######################################
#########################################################################################################################

###
# Function to create and save Terminals XML document.
###
function Create-XmlDocument
(
    [Parameter()][String]$savePath,
    [Parameter()][Object]$favorites
)
{
    # Create a new XML file
    [System.XML.XMLDocument]$xmlDoc=New-Object System.XML.XMLDocument;
    $xmlDoc.CreateXmlDeclaration("1.0","UTF-8",$null);
    # Add root node
    [System.XML.XMLElement]$xmlRoot=$xmlDoc.CreateElement("favorites");
    # Append as child to document
    $xmlDoc.appendChild($xmlRoot);

    # Loop for each favorite in the array
    foreach($fav in $favorites)
    {
        # Create new favorite element and add the child property elements
        [System.XML.XMLElement]$xmlFav=$xmlDoc.CreateElement("favorite");
        $xmlFav.appendChild($xmlDoc.CreateElement("protocol")).AppendChild($xmlDoc.CreateTextNode($fav.Protocol));
        $xmlFav.appendChild($xmlDoc.CreateElement("port")).AppendChild($xmlDoc.CreateTextNode($fav.Port));
        $xmlFav.appendChild($xmlDoc.CreateElement("name")).AppendChild($xmlDoc.CreateTextNode($fav.Name));
        $xmlFav.appendChild($xmlDoc.CreateElement("serverName")).AppendChild($xmlDoc.CreateTextNode($fav.ServerName));
        $xmlFav.appendChild($xmlDoc.CreateElement("tags")).AppendChild($xmlDoc.CreateTextNode($fav.Tags));
        $xmlFav.appendChild($xmlDoc.CreateElement("notes")).AppendChild($xmlDoc.CreateTextNode($fav.Notes));
        $xmlFav.appendChild($xmlDoc.CreateElement("credential")).AppendChild($xmlDoc.CreateTextNode($fav.Credential));
        $xmlFav.appendChild($xmlDoc.CreateElement("enableNLAAuthentication")).AppendChild($xmlDoc.CreateTextNode($fav.EnableNLAAuthentication));
        $xmlFav.appendChild($xmlDoc.CreateElement("bitmapPeristence")).AppendChild($xmlDoc.CreateTextNode($fav.BitmapPeristence));
        $xmlFav.appendChild($xmlDoc.CreateElement("url")).AppendChild($xmlDoc.CreateTextNode($fav.Url));
        
        # Appand favorite element to the root element
        $xmlRoot.appendChild($xmlFav);
    }

    # Save File
    [System.IO.TextWriter]$sw = New-Object System.IO.StreamWriter($savePath, [Boolean]::true, [System.Text.EnCoding]::UTF8);
    $xmlDoc.Save($sw);
    $sw.Flush();
    $sw.Close();
    $sw.Dispose();
}

###
# Function to create a new favorite object.
###
function New-Favorite
(
	[Parameter()][String]$name, 		# Connection name
	[Parameter()][String]$serverName,	# Computer name (FQDN) to connect to
	[Parameter()][String]$tags,			# Name of groups favorite belongs to, seperated by a comma
	[Parameter()][String]$notes,		# Extra note for favorite
	[Parameter()][String]$credential	# Name of saved managed credential
)
{
	$fav = New-Object PSObject;
	$fav | Add-Member -MemberType NoteProperty -Name Name -Value $name;
	$fav | Add-Member -MemberType NoteProperty -Name ServerName -Value $serverName;
	$fav | Add-Member -MemberType NoteProperty -Name Protocol -Value "RDP";
	$fav | Add-Member -MemberType NoteProperty -Name Port -Value "3389";
	$fav | Add-Member -MemberType NoteProperty -Name Tags -Value $tags;
	$fav | Add-Member -MemberType NoteProperty -Name Notes -Value $notes;
	$fav | Add-Member -MemberType NoteProperty -Name Credential -Value $credential;
	$fav | Add-Member -MemberType NoteProperty -Name EnableNLAAuthentication -Value $true;
	$fav | Add-Member -MemberType NoteProperty -Name BitmapPeristence -Value "RDP";
	$fav | Add-Member -MemberType ScriptProperty -Name Url -Value {"rdp://$($this.ServerName):3389/"};
	
	return $fav;
}


##############
# Change as needed
##############


$dnsPrefix='parks65i'
$vmCnt = 3


# Set path to save the terminals XML file
$xmlSavePath = "C:\TEMP\terminals\terminals.inp.xml";

# Create array for favorites
$favCollection = @();

##############
# Add your own code here to add your own favorites to the array collection
##############

for($i=1; $i -le $vmCnt; $i++){
    $favCollection += New-Favorite -name "$dnsPrefix$i" -serverName "$dnsPrefix$i.westus.cloudapp.azure.com" -tags "West"-credential "AZTest"
}

##############

# Call function to create Terminals XML document with generated favorite object array
Create-XmlDocument -savePath $xmlSavePath -favorites $favCollection

