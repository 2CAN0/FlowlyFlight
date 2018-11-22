final int KEY_LIMIT = 1024;
final int MAX_SCORES = 10;
boolean[] keysPressed = new boolean[KEY_LIMIT];
boolean hsUpdated = false;
boolean enterPressed = false;
String hsLocation = "data/highScore.csv";
String playerName = "AAA";

Player player;
PlayerLauncher playerLauncher;
Collectables coin;
Tutorial ttlTutorial;
GameOver dead;
Stamina stamina;
HighScore hs;
Animation blueBird;

/////DEV-MODE BEVAT coole en rare mechanics xD//////
boolean devMode = false;
////////////////////////////////////////////////////

PFont font;
float defaultOverallVX;
float playerTotalStam;
float totalPlayerVx;
PImage wallpaper;

//Menu
Menu menu;
String gameName = "Fowly Flight";
String[] options = {"Play", "Exit"};
boolean inMenu = true;
boolean playGame = false;

//Collectables
float collectedCoins = 0;
StopWatchTimer timer2;

//Enemies
///Enemy Buildings
final int MAX_BUILDINGS = 2;

///Enemy Airplane
StopWatchTimer timer;
float enemiesCount = 1, 
  spawn = (random(5, 8));

//Score
Score score;

//Tutorial
PImage spaceBar;
PFont tutText;
float ttlH = 160;
float ttlW = 340;

void mainSetup() {
  //Wallpaper
   wall.add(loadImage("Sprites/backGround.png"));
  wall.add(loadImage("Sprites/backGround2.png"));
  
  //Collectables
  timer2 = new StopWatchTimer();
  
  //Enemies
  timer = new StopWatchTimer();
  wallpaper = loadImage("Sprites/backgroundGrey.png");
  
  //General
  player = new Player();
  hs = new HighScore(loadTable(hsLocation, "header"), hsLocation, MAX_SCORES, 350, 400);
  playerLauncher = new PlayerLauncher();
  coin = new Collectables(player.vx);
  playerTotalStam = player.vx;
  totalPlayerVx = player.vx;
  dead = new GameOver(width/2, height/2 - 40, 225, 100, "OMG You dieded!\n\n Press A to restart", 30);
  menu = new Menu(options, gameName, wall);

  //player
  blueBird = new Animation("Sprites/ducky_", 2);
  
  //Tutorial
  spaceBar = loadImage("Sprites/spaceBar.png");
  tutText = loadFont("tutFont.vlw");
  
  enemies.add(new Enemy(30, 30, 10));
  font = loadFont("data/8BIT.vlw");
  setupBuilding();
  setupWall(); 
  setupScore();
  setupTutorial();
  setupStamina();
}
