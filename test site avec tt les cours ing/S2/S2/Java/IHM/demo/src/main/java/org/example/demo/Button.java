package org.example.demo;

import javafx.application.Application;
import javafx.scene.Scene;
import javafx.stage.Stage;

public class Button extends Application {
    public void start(Stage primaryStage) throws Exception {
        primaryStage.setTitle("Button2");
        javafx.scene.control.Button button = new javafx.scene.control.Button(/*"Click Me"*/);
        button.setPrefSize(400,100);
        Scene scene = new Scene(button);
        //button.setStyle("-fx-background-color: red; -fx-border-color: blue; -fx-text-fill: white;");
        //scene.getStylesheets().add("style.css");
        //scene.getStylesheets().add(getClass().getResource("styles").toExternalForm());
        primaryStage.setScene(scene);
        primaryStage.show();
    }/*
    public static void main(String[] args) {
        launch(args);
    }*/
}
