package org.example.demo1;

import javafx.application.Application;
import javafx.fxml.FXMLLoader;
import javafx.scene.Scene;
import javafx.stage.Stage;

import java.io.IOException;

public class HelloApplication extends Application {
    @Override
    public void start(Stage stage) throws IOException {
        /*FXMLLoader fxmlLoader = new FXMLLoader(HelloApplication.class.getResource("hello-view.fxml"));
        Scene scene = new Scene(fxmlLoader.load(), 320, 240);
        stage.setTitle("Hello!");
        stage.setScene(scene);
        stage.show();*/
        stage.setTitle("Button2");
        javafx.scene.control.Button button = new javafx.scene.control.Button(/*"Click Me"*/);
        Scene scene = new Scene(button);
        scene.getStylesheets().add("style.css");
        button.setPrefSize(200,200);
        button.getStylesheets().add("style.css");
        button.setId("button");
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }
}