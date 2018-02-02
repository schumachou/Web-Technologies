<?php 
  header("Content-Type: application/json;charset=utf-8");
  header('Access-Control-Allow-Origin: *');
  require_once __DIR__ . '/php-graph-sdk-5.0.0/src/Facebook/autoload.php';
  $fb = new Facebook\Facebook([
  'app_id' => '403903756628437',
  'app_secret' => '1bbeb195b5e87f4bade4e71fe0fc9e75',
  'default_graph_version' => 'v2.8',
  ]);

  if(isset($_GET["keyword"])){ 

    //replace space with "+" in the keyword field
    $keyArray = explode(" ", $_GET["keyword"]);
    $key = "";
    for($i=0;$i<sizeof($keyArray);$i++){
      $key .= $keyArray[$i];
      if($i != sizeof($keyArray)-1){
         $key .= "+";
      }
    }
    
    $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=user&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
    $fb_json = file_get_contents($fb_url);
    $user_obj = json_decode($fb_json);
   

    $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=page&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
    $fb_json = file_get_contents($fb_url);
    $page_obj = json_decode($fb_json);
    

    $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=event&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
    $fb_json = file_get_contents($fb_url);
    $event_obj = json_decode($fb_json);  
    
    if(isset($_GET["latitude"]) && isset($_GET["longitude"])){
      $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=place&center=".$_GET["latitude"].",".$_GET["longitude"]."&distance=&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
    }else{//for mobile
      $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=place&center=34.030,-118.287&distance=&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
    }
//    if(isset($_GET["latitude"]) && isset($_GET["longitude"])){
//      $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=place&fields= id,name,picture.width(700).height(700)&center=".$_GET["latitude"].",".$_GET["longitude"]."&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
//    }else{//for mobile
//      $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=place&fields= id,name,picture.width(700).height(700)&center=34.030,-118.287&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
//    }
    $fb_json = file_get_contents($fb_url);
    $place_obj = json_decode($fb_json);

    $fb_url = "https://graph.facebook.com/v2.8/search?q=".$key."&type=group&fields=id,name,picture.width(700).height(700)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
    $fb_json = file_get_contents($fb_url);
    $group_obj = json_decode($fb_json);

    $myObj = new stdClass();
    $myObj->user = $user_obj;
    $myObj->page = $page_obj;
    $myObj->event = $event_obj;
    $myObj->place = $place_obj;
    $myObj->group = $group_obj;
    echo json_encode($myObj);
   

  }else if(isset($_GET["id"])){
    if($_GET["type"] == "event"){
      $eventObj = new stdClass();
      $eventObj->data = "event has no detail";
      echo json_encode($eventObj);
    }else{
      //url from hw6
      $fb_url = "https://graph.facebook.com/v2.8/".$_GET["id"]."?fields=id,name,picture.width(700).height(700),albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5)&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
      //url from hw8(weird)
//      $fb_url = "https://graph.facebook.com/v2.8/".$_GET["id"]."?fields=albums.limit(5){name,photos.limit(2){name,picture}},posts.limit(5){created_time}&access_token=EAAFvWSvv8dUBANa7EonctP6hcNZC8uDtvkMTdYYiMAyEGwwOdjOz9GmdITVzx7NzHrOpVz69iFoz0FHc5D4oESc8nHYvFEb6YpHj0bUMSrSdISBlmwU2sC0LN5ayTbJl7oOYjMTCrCrZAR9Vgt";
      $fb_json = file_get_contents($fb_url);
      echo $fb_json;
    }
  }else{
    $errorObj = new stdClass();
    $errorObj->data = "somthing went wrong";
    echo json_encode($errorObj);
  }

?>