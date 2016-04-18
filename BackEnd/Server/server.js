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
                res.writeHead(200, { "Content-type": "application/json" });
                res.write(JSON.stringify(rows));
                res.end();
            }
            else {
                res.writeHead(406, { "error-code": err.code });
                console.log(err);
                res.write(err.code);
                res.end();
                return;
            }
        });

        connection.on('error', function (err) {
            res.writeHead(406, { "error-code": err.code });
            console.log(err);
            res.write(err.code);
            res.end();
            return;
        });
    });
}

function users(request, response) {
    console.log("users");
    var sql = "SELECT id, Name, picture_small FROM userdata";
    execute_query(request, response, sql, [])
}

function userData(request, response) {
    console.log("userdata");
    var parameters = request.headers["parameters"];
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
        response.writeHead(406, { "error-code": err.code });
        console.log(err);
        response.write(err.code);
        response.end();
        return;
    }
}

app.use('/users', users);
app.use('/userData', userData);
var port = process.env.OPENSHIFT_NODEJS_PORT || 8080;
var ip = process.env.OPENSHIFT_NODEJS_IP || "127.0.0.1";
process.setMaxListeners(0);
http.createServer(app).listen(port, ip);
console.log("Server is running; ");