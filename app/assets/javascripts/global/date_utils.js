//function parseISO8601(str) {
//  // we assume str is a UTC date ending in 'Z'
//  var parts = str.split('T'),
//    dateParts = parts[0].split('-'),
//    timeParts = parts[1].split('Z'),
//    timeSubParts = timeParts[0].split(':'),
//    timeSecParts = timeSubParts[2].split('.'),
//    timeHours = Number(timeSubParts[0]),
//    _date = new Date;
//
//  _date.setUTCFullYear(Number(dateParts[0]));
//  _date.setUTCMonth(Number(dateParts[1])-1);
//  _date.setUTCDate(Number(dateParts[2]));
//  _date.setUTCHours(Number(timeHours));
//  _date.setUTCMinutes(Number(timeSubParts[1]));
//  _date.setUTCSeconds(Number(timeSecParts[0]));
//  if (timeSecParts[1]) _date.setUTCMilliseconds(Number(timeSecParts[1]));
//
//  // by using setUTC methods the date has already been converted to local time(?)
//  return _date;
//}

function parseISO8601(isodatetime) {
  if (isodatetime) {
    var newdate = isodatetime.replace(/^(\d{4})-(\d{2})-(\d{2})T([0-9:]*)([.0-9]*)(.)(.*)$/,'$1/$2/$3 $4 GMT');
    newdate = Date.parse(newdate) + 1000*RegExp.$5;
    var k = +1;
    newdate -= k * Date.parse('1970/01/01 '+RegExp.$7+' GMT') * (RegExp.$6+'1');
    return new Date(newdate);
  } else {
    return isodatetime
  }
}
