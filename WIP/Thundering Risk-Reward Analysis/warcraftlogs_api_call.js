function buildHeaders() {
  return [
    'reportCode',
    'fightId',
    'encounterId',
    'keystoneLevel',
    'keystoneTime',
    'affixOne',
    'affixTwo',
    'affixThree',
    'affixFour',
    'playerId',
    'playerName',
    'playerSpec',
    'totalDamage',
    'thunderingDamage',
    'totalDeaths',
    'thunderingTime',
    'primalOverloads',
    'lightningStrikes',
    'deathsTwoAfterOverload',
    'deathsFiveAfterOverload',
    'deathsTenAfterOverload',
    'deathsTwoAfterStrike',
    'deathsFiveAfterStrike',
    'deathsTenAfterStrike'
  ];
}
 
function buildRows(fight) {
  if (fight.data == null) {
    return [[fight.reportCode, fight.fightId, 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null'],['null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null'],['null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null'],['null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null'],['null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null']];
  }
  if (fight.data.fights[0] == null) {
    return [[fight.reportCode, fight.fightId, 'null2', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null'],['null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null'],['null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null'],['null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null'],['null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null', 'null','null', 'null', 'null', 'null']];
  }
  const fightColumns = [fight.reportCode, fight.fightId, fight.data.fights[0].encounterID, fight.data.fights[0].keystoneLevel, fight.data.fights[0].keystoneTime, fight.data.fights[0].keystoneAffixes[0], fight.data.fights[0].keystoneAffixes[1], fight.data.fights[0].keystoneAffixes[2], fight.data.fights[0].keystoneAffixes[3]];
 
  const playerIds = fight.data.totalDamage.data.entries
    .filter(entry => entry.type !== "NPC")
    .map(entry => entry.id);
 
  const playersColumns = playerIds.map(id => {
    const totalDamageEntry = fight.data.totalDamage.data.entries.find(entry => entry.id === id);
    var thunderingDamageEntry = fight.data.thunderingDamage.data.entries.find(entry => entry.id === id);
    if (thunderingDamageEntry == undefined) {
      thunderingDamageEntry = {total:0};
    };
    const deaths = fight.data.deaths.data.entries.filter(entry => entry.id === id);
    const thunderingMarks = fight.data.thunderingMarkEvents.data.filter(entry => entry.targetID === id);
    const primalOverloads = fight.data.primalOverloadEvents.data.filter(entry => entry.targetID === id);
    const lightningStrikes = fight.data.lightningStrikeEvents.data.filter(entry => entry.targetID === id);
 
    const marksAdjusted = thunderingMarks.filter(function (thunderingMarkEvent) {
      return (thunderingMarkEvent.type === "removedebuff" || thunderingMarks.some(event => event.type === "removedebuff" && event.timestamp > thunderingMarkEvent.timestamp));
    });
 
    const deathsTwoAfterOverload = primalOverloads.filter(function (overloadEvent) {
      return deaths.some(death => (death.timestamp < overloadEvent.timestamp + 2000 && death.timestamp > overloadEvent.timestamp));
    });
    const deathsFiveAfterOverload = primalOverloads.filter(function (overloadEvent) {
      return deaths.some(death => (death.timestamp < overloadEvent.timestamp + 5000 && death.timestamp > overloadEvent.timestamp));
    });
    const deathsTenAfterOverload = primalOverloads.filter(function (overloadEvent) {
      return deaths.some(death => (death.timestamp < overloadEvent.timestamp + 10000 && death.timestamp > overloadEvent.timestamp));
    });
    const deathsTwoAfterStrike = lightningStrikes.filter(function (strikeEvent) {
      return deaths.some(death => (death.timestamp < strikeEvent.timestamp + 2000 && death.timestamp > strikeEvent.timestamp));
    });
    const deathsFiveAfterStrike = lightningStrikes.filter(function (strikeEvent) {
      return deaths.some(death => (death.timestamp < strikeEvent.timestamp + 5000 && death.timestamp > strikeEvent.timestamp));
    });
    const deathsTenAfterStrike = lightningStrikes.filter(function (strikeEvent) {
      return deaths.some(death => (death.timestamp < strikeEvent.timestamp + 10000 && death.timestamp > strikeEvent.timestamp));
    });
 
    const name = totalDamageEntry.name;
    const spec = totalDamageEntry.icon;
    const totalDamage = totalDamageEntry.total;
    const thunderingDamage = thunderingDamageEntry.total;
    const totalDeaths = deaths.length;
    const totalPrimalOverloads = primalOverloads.length;
    const totalLightningStrikes = lightningStrikes.length;
    const thunderingTime = marksAdjusted.reduce(function (accumulator, markEvent) {
      return (markEvent.type === "applydebuff") ? accumulator - markEvent.timestamp : accumulator + markEvent.timestamp;
    }, 0);
    const totalDeathsTwoAfterOverload = deathsTwoAfterOverload.length;
    const totalDeathsFiveAfterOverload = deathsFiveAfterOverload.length;
    const totalDeathsTenAfterOverload = deathsTenAfterOverload.length;
    const totalDeathsTwoAfterStrike = deathsTwoAfterStrike.length;
    const totalDeathsFiveAfterStrike = deathsFiveAfterStrike.length;
    const totalDeathsTenAfterStrike = deathsTenAfterStrike.length;
 
    return [
      id,
      name,
      spec,
      totalDamage,
      thunderingDamage,
      totalDeaths,
      thunderingTime,
      totalPrimalOverloads,
      totalLightningStrikes,
      totalDeathsTwoAfterOverload,
      totalDeathsFiveAfterOverload,
      totalDeathsTenAfterOverload,
      totalDeathsTwoAfterStrike,
      totalDeathsFiveAfterStrike,
      totalDeathsTenAfterStrike
    ]
  });
 
  return playersColumns.map(playerColumns => [
    ...fightColumns,
    ...playerColumns
  ]);
}
 
function writeDataToSheet() {
  const fights = getFights();
 
  console.log('Writing data to Output sheet');
 
  const values = [buildHeaders()];
 
  fights.forEach(fight => {
    values.push(...buildRows(fight));
  });
 
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Output');
  //if (sheet.getLastRow() > 1) {
  //  sheet.getRange(1, 1, sheet.getLastRow(), sheet.getLastColumn()).clear();
  //}
  sheet.getRange(sheet.getLastRow() + 1, 1, values.length, values[0].length).setValues(values);
}
 
function getFights() {
  const accessToken = getAccessToken();
  const authHeader = 'Bearer ' + accessToken;
 
  const reportCodesAndFightIds = getReportCodesAndFightIds();
  const fights = reportCodesAndFightIds.map(({reportCode, fightId}) => {
    console.log('Fetching data', reportCode, fightId);
 
    const response = UrlFetchApp.fetch("https://www.warcraftlogs.com/api/v2/client", {
      method: 'POST',
      headers: {
        Authorization: authHeader,
        'Content-Type': 'application/json'
      },
      payload: JSON.stringify({
        query: `{
  reportData {
    report(code: "${reportCode}") {
      fights(fightIDs: [${fightId}]) {
        encounterID
        keystoneLevel
        keystoneAffixes
        keystoneTime
      }
      thunderingMarkEvents: events(
	      fightIDs: [${fightId}],
	      filterExpression: "type = 'applydebuff' and ability.id IN (396369, 396364) OR type = 'removedebuff' and ability.id IN (396369, 396364)"
      ) {
        data
      }
      primalOverloadEvents: events(
        fightIDs: [${fightId}],
        filterExpression: "type = 'applydebuff' and ability.id = 396411"
      ) {
        data
      }
      lightningStrikeEvents: events(
        fightIDs: [${fightId}],
        filterExpression: "type = 'applydebuff' and ability.id = 394873"
      ) {
        data
      }
      deaths: table(
        fightIDs: [${fightId}],
        dataType: Deaths
      )
      totalDamage: table(
        fightIDs: [${fightId}],
        dataType: DamageDone
      )
      thunderingDamage: table(
        fightIDs: [${fightId}],
        dataType: DamageDone,
        filterExpression: "IN RANGE FROM type = 'applydebuff' AND ability.id IN (396369, 396364) TO type = 'removedebuff' AND ability.id IN (396369, 396364) END"
      )
    }
  }
}`
      })
    });
 
    const json = JSON.parse(response.getContentText());
 
    return {
      reportCode: reportCode,
      fightId: fightId,
      data: json.data.reportData.report
    }
  });
 
  return fights;
}
 
function getReportCodesAndFightIds() {
  const rowsSheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Credentials');
  const rowsData = rowsSheet.getDataRange().getValues();
  const startRow = rowsData[2][1];
  const numRows = rowsData[3][1];
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Report Sample');
  const data = sheet
    .getRange(startRow, 1, numRows, 2)
    .getValues()
    .map(cells => ({
      reportCode: cells[0],
      fightId: cells[1]
    }));
 
  return data;
}
 
function getClientCredentials() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName('Credentials');
  const data = sheet.getDataRange().getValues();
  const clientId = data[0][1];
  const clientSecret = data[1][1];
 
  return {
    clientId,
    clientSecret
  };
}
 
function getAccessToken() {
  const {clientId, clientSecret} = getClientCredentials();
 
  const authHeader = 'Basic ' + Utilities.base64Encode(`${clientId}:${clientSecret}`);
 
  const response = UrlFetchApp.fetch("https://www.warcraftlogs.com/oauth/token", {
    method: 'POST',
    headers: {
      Authorization: authHeader,
      'Content-Type': 'application/x-www-form-urlencoded'
    },
    payload: 'grant_type=client_credentials'
  });
 
  const json = JSON.parse(response.getContentText());
 
  return json.access_token;
}
