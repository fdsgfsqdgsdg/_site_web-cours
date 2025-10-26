package org.example.tp2;

import javafx.application.Application;
import javafx.event.ActionEvent;
import javafx.event.EventHandler;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.layout.HBox;
import javafx.stage.Stage;

public class CompteursCIA extends Application { // problème de duplication de code ! (DRY)
    public static void main(String[] args) {
        launch(args);
    }
    public void start(Stage primaryStage) {
        Button button1 = new Button("0");
        Button button2 = new Button("0");
        Button button3 = new Button("0");

        button1.setOnAction(new CompteursCI());
        button1.setPrefSize(200,200);
        button2.setOnAction(new CompteursCI());
        button2.setPrefSize(200,200);
        button3.setOnAction(new CompteursCI());
        button3.setPrefSize(200,200);

        /*button1.setOnAction(new EventHandler<ActionEvent>() {
            public void handle(ActionEvent event) {
                int num = Integer.parseInt(button1.getText());
                num++;
                button1.setText(String.valueOf(num));
            }
        });
        button1.setPrefSize(200,200);
        button2.setOnAction(new EventHandler<ActionEvent>() {
            public void handle(ActionEvent event) {
                int num = Integer.parseInt(button2.getText());
                num++;
                button2.setText(String.valueOf(num));
            }
        });
        button2.setPrefSize(200,200);
        button3.setOnAction(new EventHandler<ActionEvent>() {
            public void handle(ActionEvent event) {
                int num = Integer.parseInt(button3.getText());
                num++;
                button3.setText(String.valueOf(num));
            }
        });
        button3.setPrefSize(200,200);*/

        HBox hbox = new HBox(10, button1, button2, button3);
        Scene scene = new Scene(hbox);
        primaryStage.setScene(scene);
        primaryStage.setTitle("Compteurs CIA");
        primaryStage.show();
    }

    class CompteursCI implements EventHandler<ActionEvent> {
        @Override
        public void handle(ActionEvent event) {
            Button button = (Button) event.getSource();
            int num = Integer.parseInt(button.getText());
            num++;
            button.setText(String.valueOf(num));
        }
    }

}
