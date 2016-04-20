// JavaScript source code
var connect = require('connect');
var http = require('http');
var mysql = require('mysql');
var app = connect();


var pool = mysql.createPool({
	connectionLimit: 100,
	host: 'rapiddevcrew.com',
	user: 'rapidde_adept',
	password: '%vBsBW4P5x',
	database: 'rapidde_adept',
	debug: false
});

function respond_to_options(res) {
	// add needed headers
	var headers = {};
	headers["Access-Control-Allow-Origin"] = "*";
	headers["Access-Control-Allow-Methods"] = "POST, GET, PUT, DELETE, OPTIONS";
	headers["Access-Control-Allow-Credentials"] = true;
	headers["Access-Control-Max-Age"] = '86400'; // 24 hours
	headers["Access-Control-Allow-Headers"] = "X-Requested-With, Access-Control-Allow-Origin, X-HTTP-Method-Override, Content-Type, Authorization, Accept, parameters";
	// respond to the request
	res.writeHead(200, headers);
	res.end();
	return;

}
function execute_query(req, res, query, values) {
	
	pool.getConnection(function (err, connection) {
		if (err) {
			connection.release();
			res.writeHead(406, { "error-code": err.code });
			console.log(err);
			res.write(err.code);
			res.end();
			return;
		}
		
		console.log('connected as id ' + connection.threadId);
		var body = [];
		
		//req.on('data', function (chunk) {
		//    body.push(chunk);
		//}).on('end', function () {
		//    body = Buffer.concat(body).toString();
		//});
		//var parameters = req.headers["parameters"];
		//JSON.parse(req.headers["parameters"]);
		connection.setMaxListeners(0);
		connection.query(query, values, function (err, rows) {
			connection.release();
			if (!err) {
				var headers = {};
				headers["Access-Control-Allow-Origin"] = "*";
				headers["Content-type"] = "application/json";
				res.writeHead(200, headers);
				res.write(JSON.stringify(rows));
				res.end();
			}
			else {
				res.writeHead(400, { "error-code": err.code });
				console.log(err);
				res.write(err.code);
				res.end();
				return;
			}
		});
		
		connection.on('error', function (err) {
			connection.release();
			res.writeHead(400 , { "error-code": err.code });
			console.log(err);
			res.write(err.code);
			res.end();
			return;
			
		});
	});
}

//function execute_query_charts(query, values, callback) {
	
//	pool.getConnection(function (err, connection) {
//		if (err) {
//			connection.release();
//			callback(err, null);
//			return;
//		}
		
//		console.log('connected as id ' + connection.threadId);
//		var body = [];
		
//		connection.setMaxListeners(0);
//		console.log(values.toString());
//		connection.query(query, values, function (err, rows) {
//			connection.release();
//			if (!err) {
//				callback(null, rows);
//			}
//			else {
//				callback(err, null);
//				return;
//			}
//		});
		
//		connection.on('error', function (err) {
//			connection.release();
//			callback(err, null);
//			return;
			
//		});
//	});
//}

//function getChartData(UserId, fromDate, toDate, points, sql, callback) {
//	var step = Math.floor((toDate - fromDate) / points);
//	var addition = (toDate - fromDate) - points * step;
//	var result = [];
//	var values = [];
//	values.push(UserId);
//	for (var i = fromDate; i <= toDate - step; i += step) {
//		values[1] = i - (i == fromDate ? 1 : 0);
//		if (addition > 0) {
//			i++;
//			addition--;
//		}
//		values[2] = i + step;
//		console.log(values.toString());
//		var rows = [];
		
//			return execute_query_charts(sql, values, function (err, content) {
//				if (err) {
//					callback(err, null);
//				}
//				else {
//					rows = content;
//					result.push(JSON.stringify(rows[0]));
//					console.log(JSON.stringify(rows[0]));
//					if (result.length == points) {
//						callback(null, result);
//					}
//				}
//			});
		
//	}
//}

function getChartData(sql, parameters, callback) {
	if (!("UserId" in parameters) || !("FromDate" in parameters) || !("ToDate" in parameters) || !("Points" in parameters)) {
		var err = new Error("Parameters Error");
		callback(err, null);
		return;
	}
	var fromDate = new Date(parameters.FromDate).getTime() / 1000;
	var toDate = new Date(parameters.ToDate).getTime() / 1000;
	var step = Math.floor((toDate - fromDate) / parameters.Points);
	var addition = (toDate - fromDate) - parameters.Points * step;
	var result = [];
	var ret = "";
	var first = true;
	var parametersLoc = {
		"@UserId": parameters.UserId,
		"@FromDate": 0,
		"@ToDate":0
	}
	for (var i = fromDate; i <= toDate - step; i += step) {
		parametersLoc["@FromDate"] = i - (i == fromDate ? 1 : 0);
		if (addition > 0) {
			i++;
			addition--;
		}
		parametersLoc["@ToDate"] = i + step;
		if (first == true) {
			first = false;
		}
		else {
			ret += "\nUNION ALL\n";
		}
		ret += sql.replace(/(@\w+)/g, function (column) { 
			return (column in parametersLoc? mysql.escape(parametersLoc[column]):column);
		});
	}
	callback(null, ret);
}

function users(request, response) {
	console.log("users");
	if (request.method === 'OPTIONS') {
		respond_to_options(response);
		return;
	}
	var sql = "SELECT id, Name, picture_small FROM userdata";
	execute_query(request, response, sql, [])
}

function userData(request, response) {
	console.log("userdata");
	var parameters = request.headers["parameters"];
	if (request.method === 'OPTIONS') {
		respond_to_options(response);
		return;
	}
	if (parameters != null) {
		var values = [];
		parameters_json = JSON.parse(parameters);
		values.push(parameters_json[0].UserId);
		var sql = "select ud.id as UserId, ud.Name, ud.Age, udh.Height, ud.Title, ud.OverallCondition, udw.Weight, udm.avgForce, udwr.WristCirc, udc.CaloriesBalance, udhr.avgHeartRate as RestingHeartRate, ud.picture_big from userdata ud\
                    left join (select Weight, UserId from userdata_weight udw where timestamp = (select max(timestamp) from userdata_weight udw2 where udw2.UserId = udw.UserId)) udw on ud.id = udw.userId\
                    left join (select UserId, AVG(AppliedForce) as avgForce from userdata_musclestrength group by userId) udm on ud.id = udm.userid\
                    left join (select WristCirc, UserId from userdata_wristbonestructure udwr where timestamp = (select max(timestamp) from userdata_wristbonestructure udwr2 where udwr2.UserId = udwr.UserId)) udwr on ud.id = udwr.userId\
                    left join (select UserId, AVG(HeartRate) as avgHeartRate from userData_RestingHeartRate group by userId) udhr on ud.id = udhr.userid\
                    left join (select CaloriesBalance, UserId from userdata_calories udc where timestamp = (select max(timestamp) from userdata_calories udc2 where udc2.UserId = udc.UserId)) udc on ud.id = udc.userId\
                    left join (select Height, UserId from userdata_height udh where timestamp = (select max(timestamp) from userdata_height udh2 where udh2.UserId = udh.UserId)) udh on ud.id = udh.userId\
                    where ud.id = ?";
		execute_query(request, response, sql, values);
	}
	else {
		response.writeHead(400, { "error-code": 400 });
		response.write("400");
		response.end();
		return;
	}
}

function Chart(request, response, sql) {
	
	var parameters = request.headers["parameters"];
	if (request.method === 'OPTIONS') {
		respond_to_options(response);
		return;
	}
	if (parameters != null) {
		
		parameters_json = JSON.parse(parameters);
		
		getChartData(sql, parameters_json[0], function (err, res) {
			if (err) {
				response.writeHead(400, { "error-code": err.code });
				console.log(err);
				response.write(err.code);
				response.end();
				return;
			}
			else {
				console.log(res);
				execute_query(request, response, res, [])
			}
		});
		
	}
	else {
		response.writeHead(400, { "error-code": 400 });
		console.log('400');
		response.write(400);
		response.end();
		return;
	}
}

function weightChart(request, response) {
	console.log("weightChart");
	var sql = "select avg(Weight) as Weight from userdata_weight where UserId = @UserId and unix_timestamp(Timestamp)> @FromDate and unix_timestamp(Timestamp) <= @ToDate";
	Chart(request, response, sql);
}

function msChart(request, response) {
	console.log("msChart");
	var sql = "select avg(AppliedForce) as 'Muscle_strenght' from userdata_musclestrength where UserId = @UserId and unix_timestamp(Timestamp)> @FromDate and unix_timestamp(Timestamp) <= @ToDate";
	console.log(sql);
	Chart(request, response, sql);
}

function wbsChart(request, response) {
	console.log("wbsChart");
	var sql = "select max(WristCirc) as WristCirc from (select WristCirc from userdata_wristbonestructure where UserId = @UserId and unix_timestamp(Timestamp)> @FromDate and unix_timestamp(Timestamp) <= @ToDate ORDER BY TIMESTAMP DESC LIMIT 1) a";
	Chart(request, response, sql);
}

function cbChart(request, response) {
	console.log("cbChart");
	var sql = "select max(CaloriesBalance) as CaloriesBalance from (select CaloriesBalance from userdata_calories where UserId = @UserId and unix_timestamp(Timestamp)> @FromDate and unix_timestamp(Timestamp) <= @ToDate ORDER BY TIMESTAMP DESC LIMIT 1) a";
	Chart(request, response, sql);
}

function rhChart(request, response) {
	console.log("rhChart");
	var sql = "select avg(HeartRate) as 'HeartRate' from userData_RestingHeartRate where UserId = @UserId and unix_timestamp(Timestamp)> @FromDate and unix_timestamp(Timestamp) <= @ToDate";
	console.log(sql);
	Chart(request, response, sql);
}

function select(request, response, tableName, userid) {
	if (request.method === 'OPTIONS') {
		respond_to_options(response);
		return;
	}
	if (userid == true) {
		var parameters = request.headers["parameters"];
		if (parameters != null) {
			var values = [];
			parameters_json = JSON.parse(parameters);
			values.push(parameters_json[0].UserId);
			var sql = "SELECT * FROM " + tableName + " where "+(userid==true?"UserId":"id")+" = ?";
			console.log(sql);
			execute_query(request, response, sql, values);
		}
		else {
			response.writeHead(400, { "error-code": 400 });
			response.write("400");
			response.end();
			return;
		}
	}
	else {
		var sql = "SELECT * FROM " + tableName;
		execute_query(request, response, sql, []);
	}
}

function insert(request, response, tableName) {
	if (request.method === 'OPTIONS') {
		respond_to_options(response);
		return;
	}
	if (request.method == 'POST') {
		var body = [];
		request.on('error', function (err) {
			console.error(err);
		}).on('data', function (chunk) {
			body.push(chunk);
		}).on('end', function () {
			if (body != []) {
				body = Buffer.concat(body).toString();
				var values = [];
				var columns = "";
				var valuesstr = "";
				var first = true;
				body_json = JSON.parse(body);
				var obj = body_json[0];
				for (var key in obj) {
					var attributeValue = obj[key];
					if (first == true) {
						first = false;
					}
					else {
						columns += ", ";
						valuesstr += ", ";
					}
					key = key.replace("'", "");
					columns += key;
					//if (typeof attributeValue === 'string') {
					//	attributeValue = "'" + attributeValue + "'";
					//}
					values.push(attributeValue);
					valuesstr += '?';
				}
				
				
				var sql = "INSERT INTO " + tableName + "(" + columns + ") VALUES (" + valuesstr + ")";
				execute_query(request, response, sql, values);
			}
			else {
				response.writeHead(400, { "error-code": 400 });
				response.write("400");
				response.end();
				return;
			}
		});
	}
}

function userData_select(request, response) {
	console.log("userData_select");
	select(request, response, "userdata", true);
}
function userData_insert(request, response) {
	console.log("userData_insert");
	insert(request, response, "userdata");
}

function userData_calories_select(request, response) {
	console.log("userData_calories_select");
	select(request, response, "userdata_calories", true);
}
function userData_calories_insert(request, response) {
	console.log("userData_calories_insert");
	insert(request, response, "userdata_calories");
}

function userData_height_select(request, response) {
	console.log("userData_height_select");
	select(request, response, "userdata_height", true);
}
function userData_height_insert(request, response) {
	console.log("userData_height_insert");
	insert(request, response, "userdata_height");
}

function userdata_musclestrength_select(request, response) {
	console.log("userdata_musclestrength_select");
	select(request, response, "userdata_musclestrength", true);
}
function userdata_musclestrength_insert(request, response) {
	console.log("userdata_musclestrength_insert");
	insert(request, response, "userdata_musclestrength");
}

function userData_RestingHeartRate_select(request, response) {
	console.log("userData_RestingHeartRate_select");
	select(request, response, "userData_RestingHeartRate", true);
}
function userData_RestingHeartRate_insert(request, response) {
	console.log("userData_RestingHeartRate_insert");
	insert(request, response, "userData_RestingHeartRate");
}

function userdata_weight_select(request, response) {
	console.log("userdata_weight_select");
	select(request, response, "userdata_weight", true);
}
function userdata_weight_insert(request, response) {
	console.log("userdata_weight_insert");
	insert(request, response, "userdata_weight");
}

function userdata_wristbonestructure_select(request, response) {
	console.log("userdata_wristbonestructure_select");
	select(request, response, "userdata_wristbonestructure", true);
}
function userdata_wristbonestructure_insert(request, response) {
	console.log("userdata_wristbonestructure_insert");
	insert(request, response, "userdata_wristbonestructure");
}

function userexerciselog_select(request, response) {
	console.log("userexerciselog_select");
	select(request, response, "userexerciselog", true);
}
function userexerciselog_insert(request, response) {
	console.log("userexerciselog_insert");
	insert(request, response, "userexerciselog");
}

function recommendedexercises_select(request, response) {
	console.log("recommendedexercises_select");
	select(request, response, "recommendedexercises", true);
}
function recommendedexercises_insert(request, response) {
	console.log("recommendedexercises_insert");
	insert(request, response, "recommendedexercises");
}
app.use('/users', users);
app.use('/userData', userData);
app.use('/weightChart', weightChart);
app.use('/msChart', msChart);
app.use('/wbsChart', wbsChart);
app.use('/cbChart', cbChart);
app.use('/rhChart', rhChart);
app.use('/userData_select', userData_select);
app.use('/userData_insert', userData_insert);
app.use('/userData_calories_select', userData_calories_select);
app.use('/userData_calories_insert', userData_calories_insert);
app.use('/userData_height_select', userData_height_select);
app.use('/userData_height_insert', userData_height_insert);
app.use('/userdata_musclestrength_select', userdata_musclestrength_select);
app.use('/userdata_musclestrength_insert', userdata_musclestrength_insert);
app.use('/userData_RestingHeartRate_select', userData_RestingHeartRate_select);
app.use('/userData_RestingHeartRate_insert', userData_RestingHeartRate_insert);
app.use('/userdata_weight_select', userdata_weight_select);
app.use('/userdata_weight_insert', userdata_weight_insert);
app.use('/userdata_wristbonestructure_select', userdata_wristbonestructure_select);
app.use('/userdata_wristbonestructure_insert', userdata_wristbonestructure_insert);
app.use('/userexerciselog_select', userexerciselog_select);
app.use('/userexerciselog_insert', userexerciselog_insert);
app.use('/recommendedexercises_insert', recommendedexercises_insert);
app.use('/recommendedexercises_select', recommendedexercises_select);

var port = process.env.OPENSHIFT_NODEJS_PORT || 8080;
var ip = process.env.OPENSHIFT_NODEJS_IP || "127.0.0.1";
process.setMaxListeners(0);
http.createServer(app).listen(port, ip);
console.log("Server is running; ");