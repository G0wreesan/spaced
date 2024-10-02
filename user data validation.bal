import ballerina/http;
import ballerina/sql;
import ballerina/mysql;

// MySQL Database connection details (Update with actual credentials)
mysql:Client dbClient = check new (user = "root", password = "password", database = "timetable_db", host = "localhost", port = 3306);

service /timetable on new http:Listener(8080) 
{

    resource function post submit(http:Caller caller, http:Request req) returns error? {
        // Validate and extract form parameters
        string name = check req.getFormParamValue("User name");
        string email = check req.getFormParamValue("email");
        string occupation = check req.getFormParamValue("occupation");
        string[] days = check req.getFormParamValues("days[]");
        string[] subjects = check req.getFormParamValues("subjects[]");
        string startTime = check req.getFormParamValue("occupied_start");
        string endTime = check req.getFormParamValue("occupied_end");
        string sleepTime = check req.getFormParamValue("sleep_time");
        string studyHours = check req.getFormParamValue("study_hours");

        // Validate email format (simplified validation)
        if !email.matches("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,6}") 
        {
            check caller->respond("Invalid email format.");
            return;
        }

        // Store data into the database
        sql:ParameterizedQuery insertQuery = `INSERT INTO user_timetable
            (name, email, occupation, days, subjects, occupied_start, occupied_end, sleep_time, study_hours)
            VALUES (${name}, ${email}, ${occupation}, ${days.toString()}, ${subjects.toString()}, ${startTime}, ${endTime}, ${sleepTime}, ${studyHours})`;

        var result = dbClient->execute(insertQuery);
        if result is sql:Error {
            // Return error if there is an issue with the database
            check caller->respond("Failed to store data: " + result.message());
        } else {
            // Respond with success
            check caller->respond("Timetable successfully created for " + name + "!");
        }
    }
}