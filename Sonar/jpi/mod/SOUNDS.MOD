IMPLEMENTATION MODULE Sounds;
FROM AsmLib IMPORT Sound,Delay,NoSound;
FROM IO IMPORT KeyPressed;
FROM Lib IMPORT RANDOM,RANDOMIZE;

PROCEDURE Faucet;

VAR
    I,I2 : CARDINAL;
BEGIN
    I2 := 0;
    REPEAT
      INC(I2);
      I := 200;
      REPEAT
        Sound(I);
        Delay(12);
        INC(I, 80);
      UNTIL I > 450;
      NoSound;
    UNTIL I2 <= 1;
  END Faucet;

  PROCEDURE Phone;

  VAR
    I,I2 : CARDINAL;
  BEGIN
    I2 := 0;
    REPEAT
      INC(I2);
      FOR I := 1 TO 100 DO
        Sound(1200);
        Delay(10);
        NoSound;
      END;
    UNTIL I2 <= 1;
  END Phone;


  PROCEDURE Alert;

  VAR
    I,I2 : CARDINAL;
  BEGIN
    I2 := 0;
    REPEAT
      INC(I2);
      FOR I := 450 TO 720 DO
        Sound(I);
        Delay(3);
      END;
      NoSound;
    UNTIL I2 <= 1;
  END Alert;

PROCEDURE Computer;

  VAR
    I : CARDINAL;
  BEGIN
    REPEAT
      Sound(RANDOM(200) + 200);
      Delay(90);
      NoSound;
      Delay(50);
    UNTIL KeyPressed();
  END Computer;

  PROCEDURE Siren;

  VAR
    I,I2 : CARDINAL;
  BEGIN
    I2 := 0;
    REPEAT
    INC(I2);
      FOR I := 500 TO 2000 DO
        Delay(1);
        Sound(I);
      END;
      I :=  2000;
      WHILE I >= 500 DO
        DEC(I);
        Delay(1);
        Sound(I);
      END;
    UNTIL I2 <= 1;
    NoSound;
  END Siren;

  PROCEDURE Horse;

  VAR
    I,I2 : CARDINAL;
  BEGIN
    I2 := 0;
    REPEAT
      INC(I2);
      FOR I := 1 TO 3 DO
        IF I = 2 THEN
          Sound(250)
        ELSE
          Sound(100);
        Delay(7);
        NoSound;
        Delay(90);
      END;
      END;
      Sound(300);
      Delay(15);
      NoSound;
    UNTIL I2 <= 1;
  END Horse;

  PROCEDURE Swamp;

  VAR
    I : CARDINAL;
    Whistle : CARDINAL;

    PROCEDURE Bird;
    BEGIN
      I := 2000;
      WHILE I < 4000 DO
        Sound(I);
        INC(I);
      END;
      NoSound;
    END Bird;

  BEGIN
    RANDOMIZE;
    REPEAT
      Whistle := RANDOM(500) + 2000;
      FOR I := 1 TO 20 DO
        Sound(RANDOM(100) + Whistle);
        Delay(7);
        NoSound;
        Delay(40);
      END;
      IF RANDOM(2) = 1  THEN
        Bird;
      END;
      Delay(RANDOM(800) + 100);
      IF RANDOM(2) = 1 THEN
        Bird;
      END;
    UNTIL KeyPressed();
    NoSound;
  END Swamp;

  PROCEDURE Heart;

  VAR
    I,I2,Stop : CARDINAL;
  BEGIN
    I2 := 0;
    RANDOMIZE;
    I := 1;
    Stop := RANDOM(7) + 4;
    REPEAT
      INC(I2);
      Sound(1000);
      Delay(100);
      NoSound;
      Delay(175);
      Sound(1000);
      Delay(60);
      NoSound;
    UNTIL (I = Stop) OR (I2 <= 1);
  END Heart;

  PROCEDURE Door;

  VAR
    Sound1, Sound2, Sound3 : WORD;
    I,I2 : CARDINAL;
  BEGIN
    I2 := 0;
    REPEAT
      INC(I2);
      Sound1 := 1040;
      Sound2 := 8000;
      Sound3 := 100;
      FOR I := 1 TO 50 DO
        Sound(Sound1);
        DEC(Sound1, 20);
        Delay(2);
        Sound(Sound2);
        DEC(Sound2, 40);
        Delay(1);
        Sound(Sound3);
        DEC(Sound3);
        Delay(1);
        NoSound;
        Delay(15);
      END;
      Delay(200);
      Sound(400);
      Delay(4);
      Sound(300);
      Delay(4);
      Sound(100);
      Delay(10);
      NoSound;
    UNTIL I2 <= 1;
  END Door;

  PROCEDURE Bottle;

  VAR
    I, I2, J, S, Time : CARDINAL;
  BEGIN
    I2 := 0;
    REPEAT
      INC(I2);
      Time := 300;
      S := 100;
      FOR I := 1 TO 25 DO
        FOR J := S TO S + 20 DO
          Sound(J);
          Delay(3);
        END;
        NoSound;
        Delay(Time);
        INC(S, 10);
        DEC(Time,10);
      END;
    UNTIL I2 <= 1;
  END Bottle;

  PROCEDURE PlaneCrash;

  VAR
    I, J : CARDINAL;
    S : CARDINAL;
    E1, E2 : CARDINAL;
  BEGIN
    RANDOMIZE;
    E1 := 700;
    E2 := 500;
    FOR I := 1 TO 500 DO
      Sound(E1);
      Delay(3);
      Sound(E2);
      Delay(3);
    END;
    FOR I := 1 TO 500 DO
      Sound(E1);
      Delay(3);
      Sound(E2);
      Delay(3);
      IF RANDOM(50) = 0 THEN
        NoSound;
        Delay(RANDOM(100) + 50);
      END;
    END;
    NoSound;
    Delay(300);
    FOR I := 1 TO 200 DO
      Sound(E1);
      Delay(3);
      Sound(E2);
      Delay(3);
    END;
    FOR I := 1 TO 400 DO
      Sound(E1);
      Delay(3);
      Sound(E2);
      Delay(3);
      Sound(800);
      Delay(3);
      IF RANDOM(2) = 0 THEN
        DEC(E1, 2);
        DEC(E2, 2);
      END;
    END;
    NoSound;
    Delay(200);
    FOR J := 1 TO 1500 DO
      Sound(RANDOM(600) + 40);
      Delay(1);
    END;
    NoSound;
  END PlaneCrash;

  PROCEDURE Woods;
    PROCEDURE Bird(KindOfBird : CARDINAL; Duration : CARDINAL; Pitch : CARDINAL);
    VAR
      I, J, K : CARDINAL;
    BEGIN
      I := 1;
      CASE KindOfBird OF
        1 : WHILE I < Duration DO
            Sound(Pitch + I);
            INC(I);
          END;
          NoSound;
    |    2 : J := I + (I DIV 10);
            WHILE I < Duration DO
              Sound(Pitch + I);
              INC(I);
            END;
          NoSound;
          Delay(100);
          WHILE I > J DO
            Sound(Pitch + I);
            DEC(I);
          END;
          NoSound;
  |      3 : K := 1;
            WHILE K < RANDOM(20) + 10 DO
               Sound(Pitch);
               Delay(30);
               Sound(Pitch + (Pitch DIV 10));
               Delay(30);
               INC(K);
            END;
            NoSound;
    |    4 :  I := RANDOM(5) + 10;
             K := Pitch + (Pitch DIV 10);
               WHILE I > 1 DO
                J := Pitch;
                WHILE J < K DO
                   Sound(J);
                   Delay(6);
                   INC(J, 10);
                END;
                NoSound;
                Delay(40);
                DEC(I);
               END;
    END;
END Bird;
  BEGIN
    RANDOMIZE;
    REPEAT
      Bird( RANDOM(4)+1, RANDOM(2000) + 300, RANDOM(4000) + 200);
      Delay(RANDOM(400) + 20);
    UNTIL KeyPressed();
    NoSound;
END Woods;
BEGIN
END Sounds.