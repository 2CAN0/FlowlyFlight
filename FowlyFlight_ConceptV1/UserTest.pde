class Testing {
  Table time;
  String fileLocation;
  int starts;
  StopWatchTimer playTime = new StopWatchTimer(); 
  
  Testing(String fLocation) {
    fileLocation = fLocation;
     try{
        time = loadTable(fileLocation, "header"); 
        time.getInt(0,0);
        println("Table Loaded");
     } catch (Exception ex){
        println("!!!!!!Failed to load table we will create a new one!!!!!!!"); 
        println("Error: "+ex.getMessage());
        
        createTable();
     }
  }
  
  void createTable(){
     time = new Table();
     
     time.addColumn("id");
     time.addColumn("round time");
     time.addColumn("restarts");
     time.addColumn("average time");
     println("Table Created");
  }
  
  void startTesting(){
    playTime.start();
  }
  
  void stopTesting(){
      playTime.stop();
      TableRow newResults = time.addRow();
      newResults.setInt(0, time.getRowCount());
      newResults.setString(1, playTime.minute() + ":"+(playTime.second() - (60*playTime.minute()))); //PlayTime in miliseconds
      newResults.setInt(2, starts);
      newResults.setString(3, playTime.minute() + ":" + (playTime.getElapsedTime()/starts)/1000);
      try{
        saveTable(time, fileLocation);
        println("Table Saved");
      }catch (Exception ex){
         println("Failed to save table!!\nError: "+ex.getMessage()); 
      }      
      playTime = new StopWatchTimer();
      starts = 0;
  }
   
}
