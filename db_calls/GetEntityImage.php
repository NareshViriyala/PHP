<?php
include 'dbconnect.php';
include 'globalvariables.php';  
try {
    $mysqlconn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $id = $_REQUEST["id"];
    if($id == ""){
        return;
    }
    $stmt = $mysqlconn->prepare("CALL usp_get_EntityImage(:input)");
    $stmt->bindValue(':input', $id);
    $stmt->execute();
    $result = $stmt->fetchAll(PDO::FETCH_ASSOC);  
    $row = $result[0];
    echo $imageurl.$row['Image'];
    //header('content-type: image/jpeg');
    //echo base64_decode('images/'.$row['Image']);
    //echo base64_decode(base64_decode(file_get_contents('/images/paradise02.jpg')));
    
    //$img_file = $imagepath.'paradise02.jpg';
    //header('content-type: image/jpeg');
    //echo base64_decode($img_file);
    
    //$finfo = new finfo(FILEINFO_MIME_TYPE);
    //$type = $finfo->file($img_file);
    //echo 'data:'.$type.';base64,'.base64_encode(file_get_contents($img_file));
    
    // Read image path, convert to base64 encoding
    //$imgData = base64_encode(file_get_contents($img_file));
    
    // Format the image SRC:  data:{mime};base64,{data};
    //$src = 'data: '.mime_content_type($img_file).';base64,'.$imgData;
    
    // Echo out a sample image
    //echo '<img src="'.$src.'">';
    
    /*
    $urlParts = pathinfo($img_file);
    $extension = $urlParts['extension'];
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $img_file);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    $response = curl_exec($ch);
    curl_close($ch);
    $base64 = 'data:image/' . $extension . ';base64,' . base64_encode($response);
    echo $base64;
    //echo '<img src="'.$base64.'">';
    //echo base64_encode($response);
    */
}catch(PDOException $e){
    echo "Connection failed: ";
}
?>