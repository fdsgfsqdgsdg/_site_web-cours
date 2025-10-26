package org.example.tp4;

import javafx.scene.image.ImageView;

import java.util.Observable;
import java.util.Observer;

public class CTRLImageView implements Observer {
    private ImageView img;
    private Album album;
    public CTRLImageView(ImageView img, Album album) {
        this.img = img;
        this.album = album;
    }

    @Override
    public void update(Observable observable, Object obj) {
        Integer nbr = (Integer) obj;
        if (nbr == Album.CHANGEMENT_IMAGE_COURANTE){
            img.setImage(album.getPhotoCourante().getImage());
        }
        else if (nbr == Album.CHANGEMENT_IMAGE_COURANTE){
            img.setFitWidth(album.getPhotoCourante().getLargeur());
            img.setFitHeight(album.getPhotoCourante().getLargeur());
        }
    }
}
