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
            res.writeHead(400 , { "error-code": err.code });
            console.log(err);
            res.write(err.code);
            res.end();
            return;
        });
    });
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

function weightChart(request, response) {
    console.log("weightChart");
    var parameters = request.headers["parameters"];
    if (request.method === 'OPTIONS') {
        respond_to_options(response);
        return;
    }
    if (parameters != null) {
        var values = [];
        parameters_json = JSON.parse(parameters);
        values.push(parameters_json[0].UserId);
        var fromDate = new Date(parameters_json[0].FromDate).getTime();
        var toDate = new Date(parameters_json[0].ToDate).getTime();
        fromDate = 1460937600000;
        toDate = 1461283200001;
        console.log(fromDate);
        console.log(toDate);
        var sql = "select avg(Weight) as Weight from userdata_weight where UserId = ? and Timestamp> ? and Timestamp <= ?";
        var step = Math.floor((toDate - fromDate) / parameters_json[0].Points);
        var addition = (toDate - fromDate) - parameters_json[0].Points * step;
        console.log(addition);
        for (var i = fromDate; i <= toDate - step; i += step) {
            values[1] = i - (i == fromDate ? 1 : 0);
            if (addition > 0)
            {
                i++;
                addition--;
            }
            values[2] = i + step;
            console.log(values.toString());
            //execute_query(request, response, sql, values);
        }

        //execute_query(request, response, sql, values);
    }
    else {
        response.writeHead(400, { "error-code": 400 });
        console.log('400');
        response.write(400);
        response.end();
        return;
    } 
}

function select(request, response, tableName, userid)
{
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
			var sql = "SELECT * FROM " + tableName + " where id = ?";
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
				
				
				var sql = "INSERT INTO "+tableName+"(" + columns + ") VALUES (" + valuesstr + ")";
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
app.use('/users', users);
app.use('/userData', userData);
app.use('/weightChart', weightChart);
app.use('/userData_select', userData_select);
app.use('/userData_insert', userData_insert);
app.use('/userData_calories_select', userData_calories_select);
app.use('/userData_calories_insert', userData_calories_insert);
var port = process.env.OPENSHIFT_NODEJS_PORT || 8080;
var ip = process.env.OPENSHIFT_NODEJS_IP || "127.0.0.1";
process.setMaxListeners(0);
http.createServer(app).listen(port, ip);
console.log("Server is running; ");