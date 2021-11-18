<!--/* Copyright © 2003-2011 Rustici Software, LLC  All Rights Reserved. www.scorm.com - See LICENSE.txt for usage restrictions */-->
<!doctype html>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<html lang="en-US" xmlns:mso="urn:schemas-microsoft-com:office:office" xmlns:msdt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882">
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<head>
    <script>
        window.document.onkeypress = CheckForDebugCommand;

        var intQuestionCounter = 0;
        var ASCII_QUESTION = 63;

        function CheckForDebugCommand(e) {


            var intKeyCode = 0;
            if (window.event) {
                e = window.event;
                intKeyCode = e.keyCode;
            }
            else {
                intKeyCode = e.which;
            }

            if (intKeyCode == ASCII_QUESTION) {
                intQuestionCounter++;
                if (intQuestionCounter == 3) {
                    intQuestionCounter = 0;

                    parent.ShowDebugWindow();
                }
            }
            else if (intKeyCode != 0) {		//in FireFox, the shift key comes through as a keypress with code of 0...we want to ignore this
                intQuestionCounter = 0;
            }
        }



    </script>

<!--[if gte mso 9]><SharePoint:CTFieldRefs runat=server Prefix="mso:" FieldList="FileLeafRef"><xml>
<mso:CustomDocumentProperties>
<mso:display_urn_x003a_schemas-microsoft-com_x003a_office_x003a_office_x0023_Editor msdt:dt="string">Qurat Ulain</mso:display_urn_x003a_schemas-microsoft-com_x003a_office_x003a_office_x0023_Editor>
<mso:xd_Signature msdt:dt="string"></mso:xd_Signature>
<mso:TemplateUrl msdt:dt="string"></mso:TemplateUrl>
<mso:Order msdt:dt="string">427000.000000000</mso:Order>
<mso:ComplianceAssetId msdt:dt="string"></mso:ComplianceAssetId>
<mso:display_urn_x003a_schemas-microsoft-com_x003a_office_x003a_office_x0023_Author msdt:dt="string">Qurat Ulain</mso:display_urn_x003a_schemas-microsoft-com_x003a_office_x003a_office_x0023_Author>
<mso:xd_ProgID msdt:dt="string"></mso:xd_ProgID>
<mso:ContentTypeId msdt:dt="string">0x010100AED860A5ADE5D54095829E3C64B197C0</mso:ContentTypeId>
<mso:_SourceUrl msdt:dt="string"></mso:_SourceUrl>
<mso:_SharedFileIndex msdt:dt="string"></mso:_SharedFileIndex>
</mso:CustomDocumentProperties>
</xml></SharePoint:CTFieldRefs><![endif]-->
<title></title></head>
<body>
    &nbsp;
    <!--
    If the course does not load and is stuck on this page:
     -Click in the middle of the page
     -Press the question mark key (?) three times
     -A window should pop up containing debug information, send this information to technical support for further assistance
     -If no information appears, try again 1 or 2 more times, sometimes that just does the trick
     -->
</body>
</html>
