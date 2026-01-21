section .data
    result db 0          ; Variable pour stocker le résultat
    format db "Le résultat est %d.", 10, 0  ; Chaîne de formatage pour l'affichage

section .text
    global _start

_start:
    mov ecx, 10          ; Initialiser le compteur à 10
    mov eax, 0           ; Initialiser le résultat à zéro

loop_start:
    add eax, ecx*ecx     ; Ajouter le carré du compteur au résultat
    dec ecx              ; Décrémenter le compteur
    cmp ecx, 0           ; Vérifier si le compteur est égal à zéro
    jne loop_start       ; Boucler tant que le compteur n'est pas égal à zéro

    ; Afficher le résultat
    push eax             ; Mettre le résultat sur la pile pour printf
    push format          ; Mettre la chaîne de formatage sur la pile pour printf
    call printf          ; Appeler la fonction printf pour afficher le résultat

    ; Terminer le programme
    mov eax, 1           ; Charger le code de sortie 1 dans EAX
    xor ebx, ebx         ; Mettre EBX à zéro pour signaler une sortie normale
    int 0x80             ; Appeler le système pour terminer le programme
    


