<!doctype html>
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
</head>
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
