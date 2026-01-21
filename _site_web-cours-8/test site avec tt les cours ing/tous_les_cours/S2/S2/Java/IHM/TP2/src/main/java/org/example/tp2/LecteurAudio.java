package org.example.tp2;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.Slider;
import javafx.scene.layout.HBox;
import javafx.scene.media.Media;
import javafx.scene.media.MediaPlayer;
import javafx.stage.Stage;
import javafx.util.Duration;

import java.io.File;


public class LecteurAudio extends Application {
    public static void main(String[] args) {
        launch(args);
    }
    public void start(Stage primaryStage) {
        //Media media = new Media("file: Partenaire Particulier - Partenaire Particulier.mp3"); // ou new File("").toUri().toString()
        //Media media = new Media (new File("src/main/resources/org/example/tp2/Partenaire Particulier - Partenaire Particulier.mp3").toURI().toString());
        Media media = new Media (new File("src/main/resources/org/example/tp2/Earth, Wind & Fire - Let's Groove.mp3").toURI().toString());
        MediaPlayer mediaPlayer = new MediaPlayer(media);
        Button playButton = new Button("Play");
        playButton.setOnAction(e -> {
            if (playButton.getText().equals("Play")){
                playButton.setText("Pause");
                mediaPlayer.play();
            }
            else {
                playButton.setText("Play");
                mediaPlayer.pause();
            }
        });
        Button resetButton = new Button("<<");
        resetButton.setOnAction(e -> {
            mediaPlayer.seek(Duration.seconds(0));}
        );
        Slider slider = new Slider(0,100,50);
        mediaPlayer.volumeProperty().bind(slider.valueProperty().divide(100));
        HBox pane = new HBox(10);
        pane.getChildren().addAll(playButton, resetButton, new Label("Volume"), slider);
        Scene scene = new Scene(pane, 300,30);
        primaryStage.setScene(scene);
        primaryStage.setTitle("Lecteur Audio");
        //primaryStage.sizeToScene();
        primaryStage.show();
    }
}
