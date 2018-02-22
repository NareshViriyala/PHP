<?php
try {
    include 'dbconnect.php'; 
    $apiKeyServer = "AIzaSyBRxMBcq02DEcEfv7NtldoTTwDINuCBl-0";
    $apiKeyClient = "AIzaSyDcUmdVywbAzRl0xh69v3H3HnnUX2hrtc8";
    $senderIDServer = "1039704600442";
    $senderIDClient = "332799050304";
    $url = 'https://android.googleapis.com/gcm/send';
    //echo "Test";
    //// Open connection
    $ch = curl_init();
    curl_setopt( $ch, CURLOPT_URL, $url);
    curl_setopt( $ch, CURLOPT_POST, true);
    curl_setopt( $ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt( $ch, CURLOPT_SSL_VERIFYPEER, false);
    
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $stmt = $mysqlconn->prepare("CALL usp_get_NotificationMsgs()");
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    foreach($result as $row){
        $DeviceURL = htmlentities($row['DeviceUri']); 
        $DeviceType = htmlentities($row['DeviceType']);
        $PushMessage = $row['PushMessage'];
        $DeviceGroup = htmlentities($row['DeviceGroup']);
        
        $fields = array('registration_ids' => array($DeviceURL),'data' => array( "message" => $PushMessage),);
        
        if (strcasecmp($DeviceGroup,"Client") == 0){
            $headers = array('Authorization: key=' . $apiKeyClient,'Sender: id='. $senderIDClient,'Content-Type: application/json');
        }else if(strcasecmp($DeviceGroup,"Server") == 0){
            $headers = array('Authorization: key=' . $apiKeyServer,'Sender: id='. $senderIDServer,'Content-Type: application/json');
        }
        curl_setopt( $ch, CURLOPT_HTTPHEADER, $headers);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode( $fields));
        $pnresult = curl_exec($ch);
    }
    curl_close($ch);
}catch(PDOException $e){
    echo "Connection failed: ". $e->getMessage();
}
?>