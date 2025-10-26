package org.example.tp4;

import javafx.application.Application;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.ScrollPane;
import javafx.scene.image.ImageView;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.FlowPane;
import javafx.stage.Stage;

public class Visionneuse extends Application {
    private Album album;
    public void start(Stage window) {
        window.setTitle("Album");
        album = new Album("images");
        BorderPane root = new BorderPane();
        root.setCenter(new ScrollPane(creerCentre()));
        Scene scene = new Scene(root);
        window.setScene(scene);
        window.show();
    }

    private FlowPane creerCentre() {
        FlowPane pane = new FlowPane();
        pane.setPrefSize(600, 450);
        pane.setAlignment(Pos.BASELINE_LEFT);
        ImageView img = new ImageView(album.getPhotoCourante().getImage());
        CTRLImageView controleur = new CTRLImageView(img, album);
        pane.getChildren().add(img);
        return pane;
    }
}
