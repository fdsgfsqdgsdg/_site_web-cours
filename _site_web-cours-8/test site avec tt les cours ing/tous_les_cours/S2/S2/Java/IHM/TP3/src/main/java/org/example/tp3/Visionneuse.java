package org.example.tp3;

import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.geometry.Insets;
import javafx.geometry.Orientation;
import javafx.geometry.Pos;
import javafx.scene.Scene;
import javafx.scene.control.Button;
import javafx.scene.control.ListView;
import javafx.scene.control.ScrollPane;
import javafx.scene.control.Slider;
import javafx.scene.image.ImageView;
import javafx.scene.layout.BorderPane;
import javafx.scene.layout.FlowPane;
import javafx.scene.layout.Pane;
import javafx.stage.Stage;

public class Visionneuse extends Application {
    private Album album;
    private ImageView img;
    private Slider slider;

    public void start(Stage Windows) throws Exception {
        album = new Album("/Users/aurelienruppe/Library/Mobile Documents/com~apple~CloudDocs/Cours/CY Tech/ING1/S2/Java/IHM/TP3/src/main/resources/org/example/tp3/images");
        Windows.setTitle("Album Photo");
        BorderPane root = new BorderPane();
        root.setCenter(new ScrollPane(creerCentre()));
        root.setRight(creerSlider());
        root.setLeft(creerList());
        root.setBottom(creerBandeauBas());
        Scene scene = new Scene(root);
        Windows.setScene(scene);
        Windows.show();
    }

    private FlowPane creerCentre() {
        FlowPane pane = new FlowPane();
        pane.setPrefSize(600, 450);
        pane.setAlignment(Pos.BASELINE_LEFT);
        this.img = new ImageView(album.getPhotoCourante().getImage());
        pane.getChildren().add(img);
        return pane;
    }

    private Slider creerSlider() {
        slider = new Slider(0,300,100);
        slider.setOrientation(Orientation.VERTICAL);
        slider.setMajorTickUnit(100);
        slider.setMinorTickCount(10);
        slider.setShowTickMarks(true);
        slider.setShowTickLabels(true);
        slider.valueProperty().addListener(e -> {
            float value = (float) slider.getValue();
            album.redimensionnerPhotoCourante(value);
            img.setImage(album.getPhotoCourante().getImage());
        });
        return slider;
    }

    private ListView<String> creerList() {
        String[] listNames = new String[album.getSize()];
        for (int i = 0; i < album.getSize(); i++) {
            listNames[i] = album.getPhoto(i).getNom();
        }
        ListView listView = new ListView(FXCollections.observableArrayList(listNames));
        listView.getSelectionModel().select(album.getPhotoCourante());
        listView.getSelectionModel().selectedItemProperty().addListener(e -> {
            int value = listView.getSelectionModel().getSelectedIndex();
            album.setIndexCourant(value);
            img.setImage(album.getPhotoCourante().getImage());
            slider.setValue(album.getPhotoCourante().getZoom());
        });
        return listView;
    }

    private Pane creerBandeauBas() {
        FlowPane panneau = new FlowPane();
        panneau.setAlignment(Pos.CENTER);
        for (int i = 0; i < album.getSize(); i++) {
            Button button = new Button();
            button.setGraphic(new ImageView(album.getPhoto(i).getIcone()));
            button.setPadding(Insets.EMPTY);
            int finalI = i;
            button.setOnAction(e -> {
                album.setIndexCourant(finalI);
                img.setImage(album.getPhotoCourante().getImage());
                slider.setValue(album.getPhotoCourante().getZoom());
            });
            panneau.getChildren().add(button);
        }
        return panneau;
    }

    public static void main(String[] args) {launch(args);}
}
