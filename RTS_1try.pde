Unit units[];
Unit selected[];
Order order[];
int timer;
Factory Fwhite,Fred;

int scale=20;
int unitCount;
int selectedCount;
int orderCount;

Select select;


void setup(){
  timer=0;
  select=new Select();
  
  size(1000,1000);
  random(100);
  
  order=new Order[100];
  orderCount=0;
  units=new Unit[100000];
  unitCount=0;
  selected= new Unit[100000];
  selectedCount=0;

  
  for(int i=0;i<100;++i) units[unitCount] = new Unit((int)random(width)/2,(int)random(height),0,0);
  for(int i=0;i<100;++i) units[unitCount] = new Unit(width-(int)random(width)/2,(int)random(height),1,0);
  Fred=new Factory(width*6/8,height/2,1);
  Fwhite=new Factory(width*2/8,height/2,0);
  
}



void draw(){
  timer++;
  print_everythink();
  
  do_logic();
  
  
  
  
  
}
void print_everythink(){
  background(0,160,60);
  noStroke();
  fill(255);
  for(int i=0;i<unitCount;++i) if(units[i]!=null) { fill((units[i].owner==0)?color(250,120,120):color(255)); ellipse(units[i].x,units[i].y,units[i].hp/scale,units[i].hp/scale  );}
  stroke(0,0,100);
  strokeWeight(1);
  for(int i=0;i<unitCount;++i) if(units[i]!=null) if(units[i].order!=null) line(units[i].x,units[i].y, units[i].order.x,units[i].order.y );
  
  strokeWeight(3);
  stroke(0,0,255);
  noFill();
  for(int i=0;i<selectedCount;++i)if(selected[i]!=null) ellipse(selected[i].x,selected[i].y,selected[i].hp/scale,selected[i].hp/scale  );
  
  noStroke();
  fill(100,0,0);
  //for(int i=0;i<orderCount;++i) ellipse(order[i].x,order[i].y, order[i].strength, order[i].strength );
  
  stroke(0,0,255);
  noFill();
  if(select.selecting) select.print();
  text(orderCount,20,20);
  text(orderCount,20,40);
  text(orderCount,20,60);
  
}

void do_logic(){
  //if(timer%60==0){
    Fred.createUnit();
    Fwhite.createUnit(); 
  //}
  for(int i=0;i<unitCount;++i) if(units[i]!=null) units[i].move();
  for(int i=0;i<unitCount;++i) {
    if(units[i]!=null) {
      for(int j=i+1;j<unitCount;++j){ 
        if(units[j]!=null && units[i]!=null) {
          if(units[i].Colision(units[j])){
            
           if (units[i].hp<=0) {
             if (units[i].order!=null) units[i].order.m1(); 
             if(units[i].selnumb!=-1){
               selected[units[i].selnumb]=selected[--selectedCount];
               selected[units[i].selnumb].selnumb=units[i].selnumb;
               
             }
             units[i]=units[--unitCount];  
           }
             
           if (units[j].hp<=0) {
             if (units[i].order!=null) units[i].order.m1(); 
             if(units[j].selnumb!=-1){
               selected[units[j].selnumb]=selected[--selectedCount];
               selected[units[j].selnumb].selnumb=units[j].selnumb;
               
             }
             units[j]=units[--unitCount];  
           }
          }
        }
      }
    }
  }
}


class Unit{
  int selnumb;
  float x,y;
  float vx,vy;
  int owner;
  short range;
  float hp;
  float speed;
  int dmg;
  
  Order order;
  
  boolean Colision(Unit comper){
    if((comper.y-y)*(comper.y-y)+(comper.x-x)*(comper.x-x)<(comper.hp*comper.hp + hp*hp)/scale/scale){
      vx-=(comper.x-x)*(comper.x-x);
      vy-=(comper.y-y)*(comper.x-x);
      comper.vx+=(comper.x-x)*(comper.x-x);
      comper.vy+=(comper.y-y)*(comper.x-x);
      
      //atack;
      if(owner!=comper.owner){
        hp-=comper.dmg;
        comper.hp-=dmg;
  
      }
      return true;
    }
    return false;
  }
  
  Unit(float xS,float yS,int ownerS,int type){
    //do usuwania
    selnumb=-1;
    
    order=null;
    x=xS;
    y=yS;
    vx=0;
    vy=0;
    unitCount++;
    owner=ownerS;
    switch(type){
      case 0: 
        hp=200;
        range=20;
        speed=1;
        dmg=10;
      break;
    }
  }
  void move(){
    if(order!=null){
      vx+= (order.x-x) * sqrt(order.strength) /10;
      vy+= (order.y-y) * sqrt(order.strength) /10;
      //vx+= 1000/(order.x-x) * sqrt(order.strength) /10;
      //vy+= 1000/(order.y-y) * sqrt(order.strength) /10;
    }
    x+=vx/100;
    y+=vy/100;
    vx*=0.8;
    vy*=0.8;
  }
  void findTarget(){
    
    
  }
};



void mousePressed() {
  if( mouseButton ==RIGHT ){
    select=new Select(mouseX,mouseY);
  }
  else if(selectedCount!=0 && mouseButton ==LEFT ){
    select.giveOrder();
  }
}


  
void mouseReleased(){
  if(mouseButton ==RIGHT ){
    selectedCount=0;
    select.select();
    select=new Select();
  }
}



class Select{
  boolean selecting;
  float x,y; 
  void print(){
    rectMode(CORNERS);
    fill(0,0,150,70);
    stroke(0,0,150,150);
    rect(x,y,mouseX,mouseY);
  }
  Select(int xS,int yS){
    for(int i=0;i<unitCount;++i) units[i].selnumb=-1; 
    selecting=true;
    x=xS;
    y=yS;
  }
  Select(){
    selecting=false;
  }
  void select(){
    for(int i=0;i<unitCount;++i) if(units[i]!=null)
      if( (units[i].x > x && units[i].x < mouseX) || (units[i].x < x && units[i].x > mouseX) ) 
        if( (units[i].y > y && units[i].y < mouseY) ||(units[i].y < y && units[i].y > mouseY) ){
            units[i].selnumb=selectedCount;
            selected[selectedCount++]=units[i];
        }
    
  }
  void giveOrder(){
    order[orderCount++]=new Order(mouseX,mouseY);
    
    if(selected[0].order!=null) {
      selected[0].order.strength--;    
      if(selected[0].order.strength==0){ //jesli usunoles ostatniego
        selected[0].order=order[--orderCount]; //usuwanie z pamieci
       }
    }
  
    selected[0].order = order[orderCount-1];
    selected[0].order.strength++;
    for(int i=1;i<selectedCount;++i){
      if(selected[i].order!=null) {
        selected[i].order.strength--;    
        if(selected[i].order.strength==0){ //jesli usunoles ostatniego
          selected[i].order.m1();
          //order[orderCount-1].ID=selected[i].order.ID;
          //order[selected[i].order.ID]=order[--orderCount]; //usuwanie z pamieci
         }
      }
      selected[i].order=selected[0].order;
      selected[i].order.strength++;  
    }
  }
}


class Order{
  int ID;
  float x,y;
  int strength;
  Order(int xS,int yS){
    strength=0;
    x=xS;
    y=yS;
    ID=orderCount-1;
  }
  void m1(){
    strength--;
    if(strength<0){
      order[orderCount-1].ID=ID;
      order[ID]=order[--orderCount];
    }
    
  }
};




/*

unit->selektor
numer?





*/



class Factory{
  int owner;
  float x,y;
  void createUnit(){
    units[unitCount] = new Unit(x,y,owner,0);
    float r=random(PI);
    units[unitCount-1].vx=5*sin(r);
    units[unitCount-1].vy=5*cos(r);
    
  }
  Factory(float xS,float yS,int ownerS){
    x=xS;
    y=yS;
    owner=ownerS;
    
  }
}
