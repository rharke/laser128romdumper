; Copyright 2021 Renee Harke
;
; Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
; associated documentation files (the "Software"), to deal in the Software without restriction,
; including without limitation the rights to use, copy, modify, merge, publish, distribute,
; sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all copies or
; substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
; NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
; NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
; DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

.setcpu "65C02"

DEST            := $42
SRC1            := $3c
SRC2            := $3e
INTCXROMOFF     := $c006
INTCXROMON      := $c007
SLOTC3ROMOFF    := $c00a
SLOTC3ROMON     := $c00b
MOVE            := $fe2c

; Move the block of memory srcbegin:srcend to dest
.macro  mv      dest, srcbegin, srcend
        lda     #<dest
        sta     DEST
        lda     #>dest
        sta     DEST+1
        lda     #<srcbegin
        sta     SRC1
        lda     #>srcbegin
        sta     SRC1+1
        lda     #<srcend
        sta     SRC2
        lda     #>srcend
        sta     SRC2+1
        ldy     #$00
        jsr     MOVE
.endmacro

; Bank in a particular slot 7 ROM bank at CC00-CFFF
; Bank is in bits 4-6, so $00, $10, $20, ... $70.
.macro  s7bank  bank
        lda     $cfff
        lda     $c700
        lda     $c0e8
        lda     $c0ee
        lda     $c0ed
        lda     bank
        sta     $c0e8
.endmacro

; Fill some memory with $FF (up to 256 bytes)
.macro fillff   base, len
.scope
        lda     #$ff
        ldy     #$00
loop:   sta     base,y
        iny
        cpy     #len
        bne     loop
.endscope
.endmacro


        .org    $4000


        ; jump table - "new" Laser 128
        jmp     com0
        jmp     com2
        jmp     new4
        jmp     new6

        ; jump table - "old" Laser 128
        jmp     com0
        jmp     com2
        jmp     old4
        jmp     oldser
        jmp     old6


        ; $0000 - $1fff, common to old and new models
com0:   fillff  $2000,0             ; $C000-C0FF empty (soft switches)
        sta     INTCXROMON
        mv      $2100,$c100,$cfff   ; $C100-C7FF from main ROM
        sta     INTCXROMOFF
        fillff  $2ff8,8

        mv      $3000,$d000,$dfff   ; D000-DFFF ROM

        rts


        ; $2000 - 3fff, common to old and new models
com2:   mv      $2000,$e000,$ffff   ; E000-FFFF ROM
        rts


        ; $4000 - $5fff, new models
new4:   fillff  $2000,0             ; $C000-C0FF empty (soft switches)
        sta     SLOTC3ROMON
        mv      $2100,$c100,$c7ff   ; $C100-C7FF from slot ROM
        sta     SLOTC3ROMOFF
        fillff  $21c0,16            ; not sure, something funky with the ser/par logic

        lda     $cfff
        lda     $c100
        mv      $2800,$c800,$cfff   ; slot 1 option ROM
        fillff  $2ff8,8

        lda     $cfff
        lda     $c500
        mv      $3000,$c800,$cfff   ; slot 5 option ROM
        fillff  $37f8,8

        lda     $cfff
        lda     $c200
        mv      $3800,$c800,$cfff   ; slot 2 option ROM
        fillff  $3ff8,8

        rts


        ; $6000 - $7fff, new models
new6:   s7bank  #$00
        mv      $2000,$cc00,$cfff   ; slot 7 option ROM bank 0
        fillff  $23f8,8

        s7bank  #$10
        mv      $2400,$cc00,$cfff   ; slot 7 option ROM bank 1
        fillff  $27f8,8

        s7bank  #$20
        mv      $2800,$cc00,$cfff   ; slot 7 option ROM bank 2
        fillff  $2bf8,8

        s7bank  #$30
        mv      $2c00,$cc00,$cfff   ; slot 7 option ROM bank 3
        fillff  $2ff8,8

        s7bank  #$40
        mv      $3000,$cc00,$cfff   ; slot 7 option ROM bank 4
        fillff  $33f8,8

        s7bank  #$50
        mv      $3400,$cc00,$cfff   ; slot 7 option ROM bank 5
        fillff  $37f8,8

        lda     $cfff
        lda     $c600
        mv      $3800,$c800,$cfff   ; slot 6 option ROM
        fillff  $3ff8,8

        rts


        ; $4000 - $5fff, old models
old4:   fillff  $2000,0             ; $C000-C0FF empty (soft switches)
        mv      $2100,$c100,$c7ff   ; $C100-C7FF from slot ROM
        fillff  $2300,0             ; slot 3 does not exist
        fillff  $2500,0             ; slot 5 is always external
        fillff  $2700,0             ; slot 7 is always external
        fillff  $21c0,16            ; not sure, something funky with the ser/par logic

        lda     $cfff
        lda     $c100
        mv      $2800,$c800,$cfff   ; slot 1 option ROM
        fillff  $2ff8,8

        fillff  $3000,0             ; empty
        fillff  $3200,0
        fillff  $3300,0
        fillff  $3400,0
        fillff  $3500,0
        fillff  $3600,0
        fillff  $3700,0

        lda     $cfff
        lda     $c200
        mv      $3800,$c800,$cfff   ; slot 2 option ROM
        fillff  $3ff8,8

        rts


oldser: mv      $3100,$c100,$c1ff   ; serial version of slot 1
        rts


        ; $6000 - $7fff, old models
old6:   fillff  $2000,0             ; empty
        fillff  $2100,0
        fillff  $2200,0
        fillff  $2300,0
        fillff  $2400,0
        fillff  $2500,0
        fillff  $2600,0
        fillff  $2700,0

        lda     $cfff
        lda     $c600
        lda     $c100
        mv      $2800,$c800,$cfff   ; slot 6 option ROM bank 1
        fillff  $2ff8,8

        fillff  $3000,0             ; empty
        fillff  $3100,0
        fillff  $3200,0
        fillff  $3300,0
        fillff  $3400,0
        fillff  $3500,0
        fillff  $3600,0
        fillff  $3700,0

        lda     $cfff
        lda     $c600
        lda     $c200
        mv      $3800,$c800,$cfff   ; slot 6 option ROM bank 2
        fillff  $3ff8,8

        rts
