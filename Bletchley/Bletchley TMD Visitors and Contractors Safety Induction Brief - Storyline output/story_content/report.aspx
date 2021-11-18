<!DOCTYPE html>
<html lang="en-US" xmlns:mso="urn:schemas-microsoft-com:office:office" xmlns:msdt="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882">
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<script src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js" type="text/javascript"></script>
<script type="text/javascript" src="https://ajax.aspnetcdn.com/ajax/4.0/1/MicrosoftAjax.js"></script>
<script type="text/javascript"src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script type="text/javascript" src="/_layouts/15/init.js"></script>
<head>
  
  <meta charset="utf-8">
  <title>Results</title>
  <style>

    body {
      font-family: arial;
      text-align: center;
      font-size:10pt;
    }

    table {
      border: 1px outset grey;
    }

    td, th {
      border: 1px inset grey;
    }

    table.summary {
      width: 600px;
    }

    table.questions  {
      width: 100%;
    }

    td {
      width: 12.5%;
    }

    th, h3 {
      font-size:12pt;
    }

    h1, h2 {
      font-size:14pt;
    }

    .correct {
      color: #008800;
    }

    .incorrect {
      color: #880000;
    }

    .neutral {
      color: #000088;
    }

    .question {
      text-align: left;
      width: 46.25%;
    }

    .number {
      font-size:10pt;
      width: 3.75%;
    }

    .datetime {
      font-size:10pt;
      margin-top: 0;
      margin-bottom: 0;
    }
	
	#btnSubmit {
	  background-color: #4CAF50;
	  border: none;
	  color: white;
	  padding: 15px 32px;
	  text-align: center;
	  text-decoration: none;
	  display: inline-block;
	  font-size: 16px;
	  margin: 4px 2px;
	  cursor: pointer;
	}

  </style>
<script>

var strings = {}
try {
  strings = {
    months: [
      __MONTH_JAN__,
      __MONTH_FEB__,
      __MONTH_MAR__,
      __MONTH_APR__,
      __MONTH_MAY__,
      __MONTH_JUN__,
      __MONTH_JUL__,
      __MONTH_AUG__,
      __MONTH_SEP__,
      __MONTH_OCT__,
      __MONTH_NOV__,
      __MONTH_DEC__
    ],
    dateTime: __DATE_TIME__,
    studentScore: __STUDENT_SCORE__,
    passScore: __PASSING_SCORE__,
    courseResult: __COURSE_RESULT__,
    question: __QUESTION__,
    correctAnswer: __CORRECT_ANS__,
    quizResult: __QUIZ_RESULT__,
    studentAnswer: __STUDENT_ANS__,
    pointsAwarded: __POINTS_AWARD__,
    neutral: __NEUTRAL__,
    correct: __CORRECT__,
    incorrect: __INCORRECT__
  };
} catch (e) {
  strings = {
    months: [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ],
    dateTime: 'Date / Time',
    studentScore: 'Student Score',
    passingScore: 'Passing Score',
    courseResult: 'Result',

    question: 'Question',
    correctAnswer: 'Correct Answer',
    quizResult: 'Result',
    studentAnswer: 'Student Answer',
    pointsAwarded: 'Points Awarded',
    neutral: 'Neutral',
    correct: 'Correct',
    incorrect: 'Incorrect'
  };
}

function setupPrint(data) {
  var courseResults = data.g_oContentResults,
      quizzes = data.g_listQuizzes,
      printOptions = data.g_oPrintOptions,
      quizOrder = printOptions.arrQuizzes,
      mainQuiz = quizzes[printOptions.strMainQuizId];

  // turn date back into date object
  courseResults.dtmFinished = new Date(JSON.parse(courseResults.dtmFinished));

  function displayHeader() {
    var header = document.getElementById('header'),
        userName = printOptions.strName
        config = {
          elName: 'div',
          children: [
            { elName: 'h1', text: mainQuiz.strQuizName},
            { elName: 'h2', text: userName, enabled: userName != null && userName.length > 0},
          ]
        };

    header.appendChild(createElFromDef(config));
  }

  function displayCourseSummary() {
    var survey = printOptions.bSurvey,
        showUserScore = !survey && printOptions.bShowUserScore,
        showPassingScore = !survey && printOptions.bShowPassingScore,
        showPassFail = !survey && printOptions.bShowShowPassFail,
        studentScore = Number(mainQuiz.nPtScore),
        passingScore = Number(mainQuiz.nPassingScore),
        courseResult = (studentScore >= passingScore) ? 'Pass' : 'Fail',
        currentDateTime = formatDate(courseResults.dtmFinished),
        courseSummary = document.getElementById('courseSummary'),
        config = {
          elName: 'table',
          attrs: [{ name: 'class', value: 'summary' }, { name: 'align', value: 'center' }],
          children: [
            { elName: 'tr',
              children: [
                { elName: 'th', text: strings.dateTime},
                { elName: 'th', text: strings.studentScore, enabled: showUserScore},
                { elName: 'th', text: strings.passingScore, enabled: showPassingScore},
                { elName: 'th', text: strings.courseResult, enabled: showPassFail}
            ]},
            { elName: 'tr',
              children: [
                { elName: 'td',
                  children: [
                    { elName: 'p', attrs: [{ name: 'class', value:'datetime' }], text: currentDateTime.date },
                    { elName: 'p', attrs: [{ name: 'class', value:'datetime' }], text: currentDateTime.time }
                ]},
                { elName: 'td', text: studentScore, enabled: showUserScore },
                { elName: 'td', text: passingScore, enabled: showPassingScore },
                { elName: 'td', text: courseResult, enabled: showPassFail }
            ]}
          ]
        };

    courseSummary.appendChild(createElFromDef(config));
  }

  function displayQuizResults() {
    for (var i = 0; i < quizOrder.length; i++) {
      var quizId = quizOrder[i];
      displayQuizResult(quizId);
    }
  };

  function displayQuizResult(quizId) {
    var i, resultsTable;
        quiz = quizzes[quizId],
        questionOrder = getQuestionOrder(quiz),
        quizDiv = createQuizDiv(quiz),
        quizReview = document.getElementById('quizReview');


    quizReview.appendChild(quizDiv);
    resultsTable = document.getElementById([ 'results-', quizId ].join(''));

    for (i = 0; i < questionOrder.length; i++) {
      var config = getQuestionConfig(quiz, questionOrder[i]);
      resultsTable.appendChild(createElFromDef(config));
    }
  };

  function createQuizDiv(quiz) {
    var survey = printOptions.bSurvey;

    return createElFromDef({
      elName: 'div',
      children: [
        { elName: 'h3', text: quiz.strQuizName },
        { elName: 'table',
          attrs: [
            { name: 'class', value: 'questions' },
            { name: 'id', value: [ 'results-', quiz.strQuizId ].join('') }
          ],
          children: [
            { elName: 'tr', children: [
              { elName: 'th', text: '#' },
              { elName: 'th', text: strings.question },
              { elName: 'th', text: strings.correctAnswer, enabled: !survey},
              { elName: 'th', text: strings.studentAnswer },
              { elName: 'th', text: strings.quizResult, enabled: !survey },
              { elName: 'th', text: strings.pointsAwarded, enabled: !survey }
          ]}
        ]}
      ]
    });
  };

  function createElFromDef(elDef) {
    if (elDef.enabled === false) {
      return null;
    }

    var el = createAndInitElement(elDef.elName, elDef.attrs, elDef.text);

    if (elDef.children != null) {
      for (var i = 0; i < elDef.children.length; i++) {
        currEl = createElFromDef(elDef.children[i]);
        if (currEl != null) {
          el.appendChild(currEl);
        }
      }
    }

    return el;
  };

  function createAndInitElement(elementName, attrs, text) {
    var el = document.createElement(elementName);

    if (attrs != null) {
      for (var i = 0; i < attrs.length; i++) {
        var attr = attrs[i];
        el.setAttribute(attr.name, attr.value);
      }
    }

    if (text != null) {
      el.appendChild(document.createTextNode(text));
    }

    return el;
  };

  function getQuestionOrder(quiz) {
    var i, j,
        questionOrder = [],
        questions = quiz.arrQuestions;

    if (questions != null && questions.length > 0)  {
      // reset
      if (questions[0].found) {
        for (var i = 0; i < questions.length; i++) {
          questions[i].found = false;
        }
      }

      for (i = questions.length - 1; i >= 0; i--) {
        var index = -1,
            maxQuestionNum = -1,
            currQuestionNum;

        for (j = 0; j < questions.length; j++) {
          currQuestionNum = Number(questions[j].nQuestionNumber);
          if (!questions[j].found && currQuestionNum > maxQuestionNum) {
            maxQuestionNum = currQuestionNum;
            if (index >= 0) {
              questions[index].found = false;
            }
            questions[j].found = true;
            index = j;
          }
        }
        questionOrder[i] = index;
      }
    }

    return questionOrder;
  }

  function getQuestionConfig(quiz, questionIdx) {
    var questions = quiz.arrQuestions,
        question = questions[questionIdx],
        survey = printOptions.bSurvey;

    return {
      elName: 'tr',
      children: [
        { elName: 'td', attrs: [{ name: 'class', value: 'number'}], text: question.nQuestionNumber },
        { elName: 'td', attrs: [{ name: 'class', value: 'question'}], text: question.strDescription },
        { elName: 'td', text: formatResponse(question.strCorrectResponse), enabled: !survey},
        { elName: 'td', text: formatResponse(question.strUserResponse) },
        { elName: 'td', attrs: [{ name: 'class', value: question.strStatus}], text: strings[question.strStatus], enabled: !survey },
        { elName: 'td', text: question.nPoints, enabled: !survey }
      ]
    };
  };

  function formatResponse(response) {
    return (response != null) ? response.replace(/\|#\|/g, ', ') : '&nbsp';
  }

  function formatDate(dtm) {
    var hours = dtm.getHours(),
        period = hours >= 12 ? 'pm' : 'am',
        minutes = dtm.getMinutes().toString(),
        month = strings.months[dtm.getMonth()],
        date = dtm.getDate(),
        year = dtm.getFullYear();

    while (minutes.length < 2) {
      minutes = '0' + minutes;
    }

    if (hours > 12) {
      hours -= 12;
    }

    return {
      date: [ month, ' ', date, ', ', year ].join(''),
      time: [ hours, ':', minutes, ' ', period ].join('')
    }
  };

  function init() {
    displayHeader();
    displayCourseSummary();
    if (printOptions.bShowQuizReview) {
      displayQuizResults();
    }
  }
  init();
}

// use post message to allow this to work locally and in 360 review
window.opener.postMessage('getQuizData', '*');

window.addEventListener('message', function (e) {
  setupPrint(JSON.parse(e.data));
  createQuizResult();
}, false);
 
 //qurat script begins
 
 var appweburl = "https://realliferailway.sharepoint.com/sites/inductions";
var hostweburl = "https://realliferailway.sharepoint.com/sites/inductions";
var emptyTitle = ["Hmm… It looks like the full name ",
    "hasn’t been provided after pressing Print Results button. ",
    "Please close this browser tab, press Print Results button ",
    "again and enter your first and last names. Thank you."];

var confirmationWording = ["Please check spelling for your full name. ",
    "If incorrect, close this browser tab, press Print Results ",
    "button again and enter your first and last names. ",
    "Otherwise, please close this browser tab and the Induction Brief dialog, ",
    "then press Save button to complete your registration. Thank you."
];

var progressBar = '<div class="lmProgressContainer">' +
    '<div style="width:100%">        <div class="lmProgressClass">' +
    '</div>    </div></div>';
var progressBarStyle = ["div.lmProgressContainer {",
    "width:60%; margin: 0 auto;",
    "padding: 1px;", "margin-top: 8px;", "border-color: #AEAEAE;",
    "border: 1px solid #AEAEAE;", "}",
    ".lmProgressClass {", "animation: progressFrames 15s forwards;",
    "height: 7px;", "width: 0%;", "background-color:green", "}",
    "@keyframes progressFrames {", "0% {", "width: 0%;", "}",
    "100% {", "width:100%;", "}", "}"];
var cogMarkup = "<i class='fa fa-cog fa-spin fa-3x fa-fw' style='font-size: 1rem;'></i>";

jQuery("head").append("<style>" + progressBarStyle.join("") + "</style>");

function execCrossDomainRequest() {
    var bodyContent = jQuery("body").clone();
    bodyContent.find("script").remove();
    bodyContent.find(".lmNotice, .lmProgressContainer").remove();

    var clientContext = new SP.ClientContext(appweburl);
	//var factory = new SP.ProxyWebRequestExecutorFactory(appweburl);
    //clientContext.set_webRequestExecutorFactory(factory);
    //var appContextSite = new SP.AppContextSite(clientContext, hostweburl);
    var itemCreateInfo = new SP.ListItemCreationInformation();
    var list = clientContext.get_web().get_lists().getByTitle("Bletchley Quiz Results");
    var item = list.addItem(itemCreateInfo);
    item.set_item("Title", jQuery("h2").first().text());
    item.set_item("QuizResult", bodyContent[0].innerHTML);
    if (jQuery("table.questions tr").length <= 11) {
        item.set_item("Level", "Facility Visitor");
    }
    else {
        item.set_item("Level", "Facility Contractor");
    }
    item.update();
    clientContext.load(item, 'ID');
    clientContext.executeQueryAsync(
        function () {
            console.log("boom! list item id " + item.get_id());
            jQuery(".lmProgressContainer").fadeOut("slow");
            jQuery("body").append("<h3 class='lmNotice'></h3>");
            jQuery("h3.lmNotice").html(cogMarkup + " Redirecting, please wait...");
            var redirectUrl = hostweburl;
            if (localStorage["RegistrationId"]) {
                redirectUrl += "/Lists/Bletchley Visits/NewForm.aspx?QuizResultID=" + item.get_id();
                redirectUrl += "&RegistrationID=" + localStorage["RegistrationId"];
            }
            else {
                redirectUrl += "/Lists/Bletchley Visitors/NewForm.aspx?QuizResultID=https://realliferailway.sharepoint.com/sites/inductions/Lists/BletchleyQuizResult/DispForm.aspx?ID=" + item.get_id() + "&desc=QuizResult";
                if (jQuery("table.questions tr").length > 11) {
                    //contractor content type ID
                    redirectUrl += "&ContentTypeId=0x01000BA06A7E246F4F8B8E8C786D176E4B8000B0BA58E33DC64807B33F5CD989DD7FA1";
                }
            }
            redirectUrl += "&Source=" + "https://realliferailway.sharepoint.com/sites/inductions/SitePages/Bletchley.aspx";
            window.location.href = redirectUrl;
        },
        function (sender, args) {
            jQuery("h3.lmNotice").text("Oops, something terrible has happened: " + args.get_message());
        });

};

function createQuizResult() {

    if (jQuery("table.summary tr:nth-child(2)>td:nth-child(4)").text() == "Pass") {
        if (jQuery("h2").text() === "") {
            jQuery("h1").first().before("<h3 class='lmNotice'></h3>");
            jQuery("h3.lmNotice").text(emptyTitle.join(""));
            return;

        }

        jQuery("h1").first().before("<h3 class='lmNotice'><i class='fa fa-cog fa-spin fa-3x fa-fw'" +
    " style='font-size: 1rem;'></i>Please wait while we are saving your score report, don't close this tab yet...</h3>");
        jQuery("h3.lmNotice").after(progressBar);

        var scriptBase = hostweburl + "/_layouts/15/";
        jQuery.getScript("https://ajax.aspnetcdn.com/ajax/4.0/1/MicrosoftAjax.js", function () {
            jQuery.getScript(scriptBase + "SP.Runtime.js", function () {
                jQuery.getScript(scriptBase + "SP.js", function () {
                    jQuery.getScript(scriptBase + "SP.RequestExecutor.js", execCrossDomainRequest);
                });
            });
        });
    }
    else {

    }
};
 
</script>

</head>
<body>
  <div id="header"></div>
  <p>&nbsp;</p>
  <div id="courseSummary"></div>
  <p>&nbsp;</p>
  <div id="quizReview"></div>
</body>
</html>
