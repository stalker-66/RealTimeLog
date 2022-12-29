// Parameters
let typesList = ["Info","Warning","Error","NewSession"];
let colorTypesList = ["#ffffff","#ffe599","#ea9999","#b6d7a8"];

let sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Log');
let startDataPosition = 1;

// Post request
function doPost(e) {
  if (!e) {
    // fake request
    e = {
      parameter: {
        userId: 'userIDtest',
        platform: 'android',
        isClear: 'false',
        messages: '[{"msgText":"RealTimeLog: New session","msgType":3,"msgDate":"12/28/22 19:44:07"},{"msgText":"Hello","msgType":0,"msgDate":"12/28/22 19:44:07"},{"msgText":"Bay","msgType":0,"msgDate":"12/28/22 19:44:07"},{"msgText":"TestWarning","msgType":1,"msgDate":"12/28/22 19:44:07"},{"msgText":"TestError","msgType":2,"msgDate":"12/28/22 19:44:07"}]'
      }
    };
  };

  if (e.parameter.isClear==='true') {
    clearLog(true);
  };
  drawLog(e.parameter);

  // response
  let resp = {};
  resp.success = 1;

  return ContentService.createTextOutput(JSON.stringify(resp));
};

// Draw log
function drawLog(params) {
  params = params ? params : {};

  let userId = params.userId ? params.userId : 'undefined';
  let platform = params.platform ? params.platform : 'undefined';
  let messages = params.messages ? params.messages : '{}';
  messages = JSON.parse(messages);

  let lastRow = sheet.getLastRow();
  let startLength = lastRow + 1;
  
  let drawList = [];
  let warningList = [];
  let errorList = [];
  let newSessionList = [];

  for (let i = 0; i <= messages.length; i++) {
    if (messages[i]) {
      let msgDate = messages[i].msgDate ? messages[i].msgDate : 'undefined';
      let msgType = messages[i].msgType ? messages[i].msgType : 0;

      let msgText = messages[i].msgText ? messages[i].msgText : '';
      msgText = Utilities.base64Decode( msgText, Utilities.Charset.UTF_8 );
      msgText = Utilities.newBlob( msgText ).getDataAsString();

      let index = startLength+i;
      if (msgType==1) { warningList.push('A' + index + ':E' + index) };
      if (msgType==2) { errorList.push('A' + index + ':E' + index) };
      if (msgType==3) { newSessionList.push('A' + index + ':E' + index) };

      msgType = typesList[msgType] ? typesList[msgType] : 'undefined';

      let values = [
        msgDate,
        userId,
        msgText,
        msgType,
        platform
      ];
      drawList.push(values);
    };
  };

  if (messages.length>0) {
    let finishLength = lastRow + drawList.length;
    sheet.getRange('A' + startLength + ':E' + finishLength).setValues(drawList).setBackground(colorTypesList[0]);
  };

  if (warningList.length>0) { sheet.getRangeList(warningList).setBackground(colorTypesList[1]) };
  if (errorList.length>0) { sheet.getRangeList(errorList).setBackground(colorTypesList[2]) };
  if (newSessionList.length>0) { sheet.getRangeList(newSessionList).setBackground(colorTypesList[3]) };
};

// Clear log
function clearLog(skipErrors) {
  let lastRow = sheet.getLastRow();
  let deleteDelta = lastRow-startDataPosition;
  let sPos = startDataPosition+1;
  
  if (deleteDelta>1) {
    sheet.deleteRows(sPos, deleteDelta-1);
    sheet.getRange('A' + sPos + ':' + 'E' + sPos).setBackground(colorTypesList[0]).clearContent();
  } else if (deleteDelta==1) {
    sheet.getRange('A' + sPos + ':' + 'E' + sPos).setBackground(colorTypesList[0]).clearContent();
  } else {
    if (skipErrors && skipErrors == true) {
    } else {
      throw new Error( 'Log is empty.' );
    };
  };
};