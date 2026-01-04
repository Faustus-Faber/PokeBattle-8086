;===========================================================================
; FEATURE LIST & ATTRIBUTION
; Feature 1: Main Menu & Navigation System (By Shafi Ahmed Adib - 23101307)
; Feature 2: Pok??mon Selection System (By Shafi Ahmed Adib - 23101307)
; Feature 3: Turn-Based Battle Engine (By Farhan Zarif - 23301692)
; Feature 4: Move System with Type Effectiveness (By Farhan Zarif - 23301692)
; Feature 5: Battle UI & HP Bar Animation (By Amrin Hoque Yeana - 23301091)
; Feature 6: Victory/Defeat System with Score Tracking (By Amrin Hoque Yeana - 23301091)
;===========================================================================
.model small
.stack 100h

.data

gametitle db "##############  Pokebattle 8086 ############# $"
menuTitle db " Select Option: $"
opt1 db " 1) start $"
opt2 db " 2) help $"
opt3 db " 3) exit $"
prompt db " Enter choice (1-3): $"

startMsg db " Pokemons: $"
poke1 db " 1) Pikachu $"
poke2 db " 2) Bulbasaur $"
poke3 db " 3) Charmander $"
poke4 db " 4) Squirtle $"
poke5 db " 5) Eevee $"
poke6 db " 6) Snorlax $"

helpMsg  db " How to Play: $"
helpend  db " Press any key to continue... $"
helpMsg1 db " Press 1 to start the game $"
helpMsg2 db " Press 3 to end the game $"
helpMsg3 db " Please select 3 Pokemons $"

selectPrompt db " Enter Pokemon number (1-6): $"
invalidMsg db " Invalid choice, try again. $"
duplicate db " You cannot select one pokemon twice $"
selectedMsg db " Your selected Pokemons: $"
pressKey db " Press any button to Continue...$"

selectedArray db 3 dup(?)
selectionCount dw 0

pNames dw pn0,pn1,pn2,pn3,pn4,pn5
pn0 db "PIKACHU   $"
pn1 db "BULBASAUR $"
pn2 db "CHARMANDER$"
pn3 db "SQUIRTLE  $"
pn4 db "EEVEE     $"
pn5 db "SNORLAX   $"
pType db 4,3,2,1,0,0
pMaxHP db 35,45,39,44,40,60
pSpeed db 90,45,65,43,55,30
pDefense db 40,49,43,65,50,65

mNames dw m0,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11
       dw m12,m13,m14,m15,m16,m17,m18,m19,m20,m21,m22,m23
m0  db "THUNDERBOLT $"
m1  db "QUICK ATTACK$"
m2  db "THUNDER WAVE$"
m3  db "SLAM        $"
m4  db "VINE WHIP   $"
m5  db "RAZOR LEAF  $"
m6  db "POISON POWDR$"
m7  db "SLEEP POWDER$"
m8  db "EMBER       $"
m9  db "FLAMETHROWER$"
m10 db "SCRATCH     $"
m11 db "WILL-O-WISP $"
m12 db "WATER GUN   $"
m13 db "BUBBLE      $"
m14 db "TACKLE      $"
m15 db "HYDRO PUMP  $"
m16 db "TACKLE      $"
m17 db "QUICK ATTACK$"
m18 db "BITE        $"
m19 db "FURY SWIPES $"
m20 db "BODY SLAM   $"
m21 db "REST        $"
m22 db "HEADBUTT    $"
m23 db "HYPER BEAM  $"
mPower     db 12,8,0,10,10,12,0,0,10,14,8,0,10,8,8,15,8,8,10,3,12,0,10,18
mType      db 4,0,4,0,3,3,3,3,2,2,0,2,1,1,0,1,0,0,0,0,0,0,0,0
mPPMax     db 15,30,20,20,25,20,35,15,25,15,35,15,25,30,35,10,35,30,25,15,15,10,25,5
mAccuracy  db 100,100,90,75,100,95,75,75,100,90,100,85,100,100,100,80,100,100,100,80,100,255,100,90
mPriority  db 0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0
mFlags     db 0,0,1,0,0,0,1,1,0,4,0,1,0,0,0,0,0,0,0,8,4,1,0,2
mStatusType db 0,0,1,0,0,0,4,2,0,5,0,5,0,0,0,0,0,0,0,0,1,3,0,0
mHits      db 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1


playerTeam db 3 dup(0)
aiTeam db 3 dup(0)
playerHP db 3 dup(0)
aiHP db 3 dup(0)
playerMaxHP db 3 dup(0)
aiMaxHP db 3 dup(0)
playerPP db 12 dup(0)
aiPP db 12 dup(0)
playerItemUsed db 3 dup(0)
aiItemUsed db 3 dup(0)
activePlayer db 0
activeAI db 0
battleResult db 0
aiAvail db 6 dup(1)
aiScores db 6 dup(0)

playerStatus db 3 dup(0)
aiStatus db 3 dup(0)
playerStatusTurns db 3 dup(0)
aiStatusTurns db 3 dup(0)
playerRecharge db 3 dup(0)
aiRecharge db 3 dup(0)


effectMatrix db 1,1,1,1,1  
             db 1,1,2,0,1  
             db 1,0,1,2,1  
             db 1,2,0,1,1  
             db 1,2,1,1,1  


ai_attempts  db 3
damage       db 0

strParalyzed db " is paralyzed!$"
strAsleep db " fell asleep!$"
strPoisoned db " is poisoned!$"
strBurned db " is burned!$"
strCantMove db " can't move!$"
strWokeUp db " snapped out!$"
strRecharge db " must recharge!$"
strRested db " restored HP!$"
strMissed db " missed!$"

strEnemy db " ENEMY: $"
strYou db " YOU:   $"
strHP db " HP:$"
strSlash db "/$"
strPP db "PP:$"
strSuper db " Super effective!$"
strWeak db " Not effective...$"
strFaint db " fainted!$"
strGo db " Go! $"
strUsed db " used $"
strHeal db " Healed!$"
strWin db " YOU WIN!$"
strLose db " YOU LOSE!$"
strPick db " Select Action: $"
strSwitch db " Select Pokemon (1-3): $"
strHurtByStatus db " is hurt by status! $"
strIsSleeping   db " is fast asleep! $"


strPlayerAct db " Player Action:$"
strAIAct     db " AI Action:$"
strPressBtn  db " Press any button to Continue...$"
strIsSleeping   db " is fast asleep! $"
strDMG db " damage!$"
strFailed db " failed!$"
strCritical db " A critical hit!$"
strLine db "==========================================$" 



playerScore db 0
aiScore     db 0
roundCount  db 0

strScore db " SCORE -> YOU: $"
strCPU   db "  CPU: $"
strRound db " ROUND: $"

strStats    db " 4) View Statistics $"
strNoStats  db " No battles played yet! $"
strTotalBattles db " Total Battles: $"
strWinRate  db " Win Rate: $"
strPercent  db "%$"
strBestStreak db " Best Streak: $"
strCurrentStreak db " Current Streak: $" 
strResetStats db " Press R to reset stats, any key to continue...$"

winStreak   db 0
bestStreak  db 0
totalWins   db 0
totalLosses db 0


strMenuEmpty  db "||                                      ||$"
strMenuTitle  db "||           POKEBATTLE 8086            ||$"
strOpt1Box    db "||             1. START                 ||$"
strOpt2Box    db "||             2. HELP                  ||$"
strOpt3Box    db "||             3. EXIT                  ||$"
strOpt4Box    db "||             4. STATS                 ||$"
strSelTitle   db "||           SELECT 3 POKEMON           ||$"
strRow1       db "||  1) Pikachu        2) Bulbasaur      ||$"
strRow2       db "||  3) Charmander     4) Squirtle       ||$"
strRow3       db "||  5) Eevee          6) Snorlax        ||$"
.code

LOAD_IDX MACRO var
    mov bl,var
    mov bh,0
ENDM

PRINT MACRO msg
    lea dx,msg
    call pstr
ENDM

PRINTLN MACRO msg
    lea dx,msg
    call pstr
    call nl
ENDM

LOAD_ARR MACRO arr,idx
    LOAD_IDX idx
    mov al,arr[bx]
ENDM

SUM_HP MACRO arr
    LOCAL loop_lbl
    mov cx,3
    mov bx,0
    mov al,0
    loop_lbl:
    add al,arr[bx]
    inc bx
    loop loop_lbl
ENDM

RESET_ARR MACRO arr,val,count
    LOCAL loop_lbl
    mov cx,count
    mov si,0
    lea bx,arr
    loop_lbl:
    mov byte ptr [bx+si],val
    inc si
    loop loop_lbl
ENDM


SAFE_ADD MACRO dest, val, maxval
    LOCAL overflow, done
    push ax
    mov al, dest
    add al, val
    jc overflow
    cmp al, maxval
    jbe done
overflow:
    mov al, maxval
done:
    mov dest, al
    pop ax
ENDM

SAFE_ADD_IDX MACRO arr, maxArr, val
    LOCAL overflow, done
    push ax
    push cx
    mov al, arr[bx]
    mov cl, maxArr[bx]
    add al, val
    jc overflow
    cmp al, cl
    jbe done
overflow:
    mov al, cl
done:
    mov arr[bx], al
    pop cx
    pop ax
ENDM

APPLY_DAMAGE MACRO activeIdx, hpArr, faintProc
    LOCAL skip_dmg, done_dmg
    LOAD_IDX activeIdx
    cmp al,hpArr[bx]
    jb skip_dmg
    mov al,hpArr[bx]
    skip_dmg:
    sub hpArr[bx],al
    
    push ax
    call print_num
    PRINTLN strDMG
    pop ax
    
    cmp byte ptr hpArr[bx],0
    jne done_dmg
    call faintProc
    done_dmg:
ENDM

main proc
    mov ax, @data
    mov ds, ax

menu_loop:
    ; ==========================================
    ; Feature 1: Main Menu & Navigation System
    ; DONE BY: Shafi Ahmed Adib (23101307)
    ; ==========================================
    
    call clrscr
    
    call clrscr
    
    PRINTLN strLine
    PRINTLN strMenuTitle
    PRINTLN strLine
    PRINTLN strMenuEmpty
    PRINTLN strOpt1Box
    PRINTLN strOpt2Box
    PRINTLN strOpt3Box
    PRINTLN strOpt4Box
    PRINTLN strMenuEmpty
    PRINTLN strLine

    mov ah, 09h
    lea dx, prompt
    int 21h

    mov ah, 01h
    int 21h

    cmp al, '1'
    je do_start
    cmp al, '2'
    je do_help
    cmp al, '3'
    je do_exit
    cmp al, '4'
    je do_statistics

    call nl
    mov ah, 09h
    lea dx, invalidMsg
    int 21h
    call nl
    jmp menu_loop

    
do_start:
    ; ==========================================
    ; Feature 2: Pok??mon Selection System
    ; DONE BY: Shafi Ahmed Adib (23101307)
    ; ==========================================
    call clrscr
    call clrscr
    call nl
    
    PRINTLN strLine
    PRINTLN strSelTitle
    PRINTLN strLine
    PRINTLN strRow1
    PRINTLN strRow2
    PRINTLN strRow3
    PRINTLN strLine
    call nl

    jmp pokemonadd

pokemonadd:
    mov selectionCount, 0

select_loop:
    cmp selectionCount, 3
    je selection_done

    call nl
    mov ah, 09h
    lea dx, selectPrompt
    int 21h

    mov ah, 01h
    int 21h

    cmp al, '1'
    jl invalid_input
    cmp al, '6'
    jg invalid_input

    mov bx, 0
    mov cx, 0

check_dup:
    cmp cx, selectionCount
    je add_to_array

    mov dl, selectedArray[bx]
    cmp dl, al
    je duplicate_error

    inc bx
    inc cx
    jmp check_dup

add_to_array:
    mov bx, selectionCount
    mov selectedArray[bx], al
    inc selectionCount
    jmp select_loop

invalid_input:
    call nl
    mov ah, 09h
    lea dx, invalidMsg
    int 21h
    jmp select_loop

duplicate_error:
    call nl
    mov ah, 09h
    lea dx, duplicate
    int 21h
    jmp select_loop

selection_done:
    call nl
    call nl
    mov ah, 09h
    lea dx, selectedMsg
    int 21h
    call nl

    mov bx, 0
    mov cx, 0

display_selected:
    cmp cx, 3
    je back_to_menu

    mov al, selectedArray[bx]
    sub al, 30h

    cmp al, 1
    je printpika
    cmp al, 2
    je printb
    cmp al, 3
    je printc
    cmp al, 4
    je printsq
    cmp al, 5
    je printe
    cmp al, 6
    je printsn

printpika:
    mov ah, 09h
    lea dx, poke1
    int 21h
    call nl
    inc bx
    inc cx
    jmp display_selected
printb:
    mov ah, 09h
    lea dx, poke2
    int 21h
    call nl
    inc bx
    inc cx
    jmp display_selected
printc:
    mov ah, 09h
    lea dx, poke3
    int 21h
    call nl
    inc bx
    inc cx
    jmp display_selected
printsq:
    mov ah, 09h
    lea dx, poke4
    int 21h
    call nl
    inc bx
    inc cx
    jmp display_selected
printe:
    mov ah, 09h
    lea dx, poke5
    int 21h
    call nl
    inc bx
    inc cx
    jmp display_selected
printsn:
    mov ah, 09h
    lea dx, poke6
    int 21h
    call nl
    inc bx
    inc cx
    jmp display_selected

back_to_menu:
    call nl
    mov ah, 09h
    lea dx, pressKey
    int 21h
    mov ah, 01h
    int 21h
    call START_BATTLE
    jmp menu_loop

do_help:
    call clrscr
    call nl
    call nl
    mov ah, 09h
    lea dx, helpMsg
    int 21h

    call nl
    mov ah, 09h
    lea dx, helpMsg1
    int 21h
    call nl

    mov ah, 09h
    lea dx, helpMsg2
    int 21h
    call nl

    mov ah, 09h
    lea dx, helpMsg3
    int 21h
    call nl

    mov ah, 09h
    lea dx, helpend
    int 21h
    call nl

    mov ah, 01h
    int 21h

    call nl
    jmp menu_loop

do_exit:
    mov ax, 4C00h
    int 21h
    
    
do_statistics:
    ; ==========================================
    ; Feature 6: Victory/Defeat System with Score Tracking
    ; DONE BY: Amrin Hoque Yeana (23301091)
    ; ==========================================
    call clrscr
    call nl
    call nl
    
    mov al, roundCount
    cmp al, 0
    jne stats_show
    
    lea dx, strNoStats
    mov ah, 09h
    int 21h
    call nl
    call nl
    jmp stats_end

stats_show:
    
    lea dx, strLine
    mov ah, 09h
    int 21h
    call nl
    
    lea dx, helpMsg
    mov ah, 09h
    int 21h
    call nl
    
    lea dx, strLine
    mov ah, 09h
    int 21h
    call nl
    call nl
    
    lea dx, strTotalBattles
    mov ah, 09h
    int 21h
    mov al, roundCount
    call print_num
    call nl
    
    lea dx, strScore
    mov ah, 09h
    int 21h
    mov al, playerScore
    call print_num
    call nl
    
    lea dx, strCPU
    mov ah, 09h
    int 21h
    mov al, aiScore
    call print_num
    call nl
    call nl
    
    lea dx, strWinRate
    mov ah, 09h
    int 21h
    
    mov bl, roundCount
    cmp bl, 0
    je stats_skip_rate
    
    mov al, playerScore
    mov ah, 0
    mov cl, 100
    mul cl
    xor dx,dx
    
    mov bl,roundCount
    mov bh, 0
    div bx
    
    cmp al,100
    jbe rate_ok
    mov al,100
    rate_ok:
    call print_num
    
    lea dx, strPercent
    mov ah, 09h
    int 21h
    call nl
    jmp stats_continue

stats_skip_rate:
    mov al, 0
    call print_num
    lea dx, strPercent
    mov ah, 09h
    int 21h
    call nl

stats_continue:
    lea dx, strBestStreak
    mov ah, 09h
    int 21h
    mov al, bestStreak
    call print_num
    call nl
    
    lea dx, strCurrentStreak
    mov ah, 09h
    int 21h
    mov al, winStreak
    call print_num
    call nl
    call nl
    
    lea dx, strLine
    mov ah, 09h
    int 21h
    call nl

stats_end:
    lea dx, strResetStats
    mov ah, 09h
    int 21h
    
    mov ah, 01h
    int 21h
    
    cmp al, 'R'
    je stats_reset
    cmp al, 'r'
    je stats_reset
    jmp menu_loop

stats_reset:
    mov playerScore, 0
    mov aiScore, 0
    mov roundCount, 0
    mov winStreak, 0
    mov bestStreak, 0
    jmp menu_loop




main endp

clrscr proc
    push ax
    push bx
    push cx
    push dx
    mov ah,06h
    mov al,0
    mov bh,07h
    mov cx,0
    mov dx,184Fh
    int 10h
    mov ah,02h
    mov bh,0
    mov dx,0
    int 10h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
clrscr endp

pstr proc
    mov ah,09h
    int 21h
    ret
pstr endp

nl proc
    push ax
    push dx
    mov ah,02h
    mov dl,13
    int 21h
    mov dl,10
    int 21h
    pop dx
    pop ax
    ret
nl endp

print_poke proc
    push ax
    push bx
    mov ah,0
    cmp al,6
    jb pp_ok
    mov al,0    
pp_ok:
    mov bx,ax
    add bx,bx
    mov dx,pNames[bx]
    call pstr
    pop bx
    pop ax
    ret
print_poke endp

print_num proc
    push ax
    push bx
    push cx
    push dx
    mov ah,0
    mov bl,100
    div bl
    mov cl,ah
    cmp al,0
    je pn_skip
    add al,30h
    mov dl,al
    mov ah,02h
    int 21h
pn_skip:
    mov al,cl
    mov ah,0
    mov bl,10
    div bl
    mov cl,ah
    add al,30h
    mov dl,al
    mov ah,02h
    int 21h
    mov al,cl
    add al,30h
    mov dl,al
    int 21h
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp

;===========================================================================
;===========================================================================
START_BATTLE proc
    ; ==========================================
    ; Feature 3: Turn-Based Battle Engine
    ; DONE BY: Farhan Zarif (23301692)
    ; ==========================================
    call INIT_BATTLE
    call AI_PICK_TEAM
    mov activePlayer,0
    mov activeAI,0
    mov battleResult,0
battle_loop:
    call CHECK_END
    cmp battleResult,0
    jne battle_over
    call DRAW_UI
    mov bl,activePlayer
    mov bh,0
    mov al,playerTeam[bx]
    mov ah,0
    mov bx,ax
    mov cl,pSpeed[bx]
    mov bl,activeAI
    mov bh,0
    mov al,aiTeam[bx]
    mov ah,0
    mov bx,ax
    mov ch,pSpeed[bx]
    cmp cl,ch
    jb ai_first
    
    mov al, activeAI
    push ax
    call PLAYER_TURN
    call CHECK_END
    cmp battleResult,0
    jne battle_pop_end
    pop ax
    cmp al, activeAI
    jne battle_loop
    
    call AI_TURN
    call APPLY_STATUS_DAMAGE
    call CHECK_END
    jmp battle_loop

battle_pop_end:
    pop ax
    jmp battle_over
ai_first:
    mov al, activePlayer
    push ax
    call AI_TURN
    call CHECK_END
    cmp battleResult,0
    jne battle_pop_end
    pop ax
    cmp al, activePlayer
    jne battle_loop

    call DRAW_UI
    call PLAYER_TURN
    call APPLY_STATUS_DAMAGE
    call CHECK_END
    jmp battle_loop
       
battle_over:
    call clrscr
    call nl
    lea dx,strLine
    call pstr
    call nl
    
    cmp battleResult,1
    jne show_lose

    inc playerScore
    inc roundCount
    inc winStreak
    
    mov al, winStreak
    cmp al, bestStreak
    jle no_new_best
    mov bestStreak, al
no_new_best:
    
    lea dx,strWin
    jmp show_end

show_lose:
    inc aiScore
    inc roundCount
    mov winStreak, 0
    lea dx,strLose

show_end:
    call pstr
    call nl

    lea dx,strLine
    call pstr
    call nl
    
    lea dx,strRound
    call pstr
    mov al,roundCount
    call print_num
    call nl

    lea dx,strScore
    call pstr
    mov al,playerScore
    call print_num

    lea dx,strCPU
    call pstr
    mov al,aiScore
    call print_num
    call nl
    
    mov al, winStreak
    cmp al, 0
    je no_streak_display
    
    lea dx, strCurrentStreak
    call pstr
    mov al, winStreak
    call print_num
    call nl

no_streak_display:
    =======

    lea dx,strLine
    call pstr
    call nl
    lea dx,pressKey
    call pstr
    mov ah,01h
    int 21h
    ret
START_BATTLE endp

INIT_BATTLE proc
    push ax
    push bx
    push cx
    push si
    mov cx,3
    mov si,0
ib1:
    mov al,selectedArray[si]
    sub al,'1'
    mov playerTeam[si],al
    inc si
    loop ib1
    mov cx,3
    mov si,0
ib2:
    mov bl,playerTeam[si]
    mov bh,0
    mov al,pMaxHP[bx]
    mov playerHP[si],al
    mov playerMaxHP[si],al
    mov playerItemUsed[si],0
    mov playerRecharge[si],0
    push cx
    mov al,bl
    mov cl,4
    mul cl
    mov di,ax
    mov ax,si
    mul cl
    mov bx,ax
    mov cx,4
ib3:
    mov al,mPPMax[di]
    mov playerPP[bx],al
    inc di
    inc bx
    loop ib3
    pop cx
    inc si
    loop ib2
    RESET_ARR aiAvail, 1, 6
    mov cx,3
    mov si,0
ib5:
    mov bl,playerTeam[si]
    mov bh,0
    mov aiAvail[bx],0
    inc si
    loop ib5
    RESET_ARR playerStatus, 0, 3
    RESET_ARR aiStatus, 0, 3
    RESET_ARR playerStatusTurns, 0, 3
    RESET_ARR aiStatusTurns, 0, 3
    pop si
    pop cx
    pop bx
    pop ax
    ret
INIT_BATTLE endp

AI_PICK_TEAM proc
    push ax
    push bx
    push cx
    push si
    push di
    mov si,0
ais1:
    cmp si,6
    jge ais2
    cmp aiAvail[si],0
    je ais_next
    mov di,0
    mov dl,0
ais_vs:
    cmp di,3
    jge ais_store
    mov bx,si
    mov al,pType[bx]
    mov bl,playerTeam[di]
    mov bh,0
    mov ah,pType[bx]
    call GET_MULT
    add dl,al
    inc di
    jmp ais_vs
ais_store:
    mov aiScores[si],dl
ais_next:
    inc si
    jmp ais1
ais2:
    call FIND_BEST
    mov aiTeam[0],al
    mov bl,al
    mov bh,0
    mov aiAvail[bx],0
    call FIND_BEST
    mov aiTeam[1],al
    mov bl,al
    mov bh,0
    mov aiAvail[bx],0
    call FIND_BEST
    mov aiTeam[2],al
    mov cx,3
    mov si,0
ait1:
    mov bl,aiTeam[si]
    mov bh,0
    mov al,pMaxHP[bx]
    mov aiHP[si],al
    mov aiMaxHP[si],al
    mov aiItemUsed[si],0
    mov aiRecharge[si],0
    push cx
    mov al,bl
    mov cl,4
    mul cl
    mov di,ax
    mov ax,si
    mul cl
    mov bx,ax
    mov cx,4
ait2:
    mov al,mPPMax[di]
    mov aiPP[bx],al
    inc di
    inc bx
    loop ait2
    pop cx
    inc si
    loop ait1
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
AI_PICK_TEAM endp

FIND_BEST proc
    push bx
    push cx
    mov cx,6
    mov bx,0
    mov dl,0
    mov dh,0
fb1:
    cmp aiAvail[bx],0
    je fb2
    mov al,aiScores[bx]
    cmp al,dl
    jle fb2
    mov dl,al
    mov dh,bl
fb2:
    inc bx
    loop fb1
    mov al,dh
    pop cx
    pop bx
    ret
FIND_BEST endp

GET_MULT proc
    push bx
    push cx
    mov cl,ah
    mov ah,0
    mov bl,5
    mul bl
    add al,cl
    mov bx,ax
    mov al,effectMatrix[bx]
    pop cx
    pop bx
    ret
GET_MULT endp

CHECK_STATUS proc
    push bx
    push dx
    mov bh,0
    
    cmp cl,0
    jne cs_rech_chk_ai
    cmp playerRecharge[bx],1
    jne cs_start_status
    mov playerRecharge[bx],0
    jmp cs_do_rech
cs_rech_chk_ai:
    cmp aiRecharge[bx],1
    jne cs_start_status
    mov aiRecharge[bx],0
cs_do_rech:
    push ax
    push bx
    cmp cl,0
    jne csrb_ai
    LOAD_ARR playerTeam,activePlayer
    jmp csrb_pr
csrb_ai:
    LOAD_ARR aiTeam,activeAI
csrb_pr:
    call print_poke
    pop bx
    pop ax
    PRINTLN strRecharge
    jmp cs_skip
    
cs_start_status:
    cmp cl,0
    jne cs_ai
    mov al,playerStatus[bx]
    jmp cs_chk
cs_ai:
    mov al,aiStatus[bx]
cs_chk:
    cmp al,0
    je cs_ok
    cmp al,3
    je cs_rest
    cmp al,4
    jge cs_ok
    
    cmp cl,0
    jne cs_dec_ai
    dec playerStatusTurns[bx]
    cmp playerStatusTurns[bx],0
    jg cs_skip
    mov playerStatus[bx],0
    jmp cs_wake
cs_dec_ai:
    dec aiStatusTurns[bx]
    cmp aiStatusTurns[bx],0
    jg cs_skip
    mov aiStatus[bx],0
cs_wake:
    push ax
    push bx
    cmp cl,0
    jne csw_ai
    LOAD_ARR playerTeam,activePlayer
    jmp csw_pr
csw_ai:
    LOAD_ARR aiTeam,activeAI
csw_pr:
    call print_poke
    pop bx
    pop ax
    PRINTLN strWokeUp
    jmp cs_ok
    
cs_rest:
    cmp cl,0
    jne cs_rst_ai
    mov playerStatus[bx],0
    jmp cs_rst_msg
cs_rst_ai:
    mov aiStatus[bx],0
cs_rst_msg:
    push ax
    push bx
    cmp cl,0
    jne csrm_ai
    LOAD_ARR playerTeam,activePlayer
    jmp csrm_pr
csrm_ai:
    LOAD_ARR aiTeam,activeAI
csrm_pr:
    call print_poke
    pop bx
    pop ax
    PRINTLN strIsSleeping
    jmp cs_skip

cs_skip:
    
    
    push ax
    push bx
    cmp cl,0
    jne css_ai
    LOAD_ARR playerTeam,activePlayer
    jmp css_pr
css_ai:
    LOAD_ARR aiTeam,activeAI
css_pr:
    call print_poke
    pop bx
    pop ax
    PRINTLN strCantMove
    mov al,0
    jmp cs_done
cs_ok:
    mov al,1
cs_done:
    pop dx
    pop bx
    ret
CHECK_STATUS endp

CHECK_ACCURACY proc
    push cx
    push dx
    mov al,mAccuracy[bx]
    cmp al,255
    je ca_hit
    push ax
    push bx
    mov ah,0
    int 1Ah
    mov al,dl           
    mov ah,0            
    mov bl,100
    div bl              
    inc ah             
    mov cl,ah
    pop bx
    pop ax
    cmp cl,al
    jle ca_hit
    lea dx,strMissed
    call pstr
    call nl
    mov al,0
    jmp ca_done
ca_hit:
    mov al,1
ca_done:
    pop dx
    pop cx
    ret
CHECK_ACCURACY endp

APPLY_STATUS_DAMAGE proc
    push ax
    push bx
    LOAD_IDX activePlayer
    mov al,playerStatus[bx]
    cmp al,4
    je asd_p
    cmp al,5
    jne asd_ai
asd_p:
    mov al,playerMaxHP[bx]
    shr al,3
    cmp al,0
    jne asd_p1
    mov al,1
asd_p1:
    cmp al,playerHP[bx]
    jb asd_p2
    mov al,playerHP[bx]
asd_p2:
    sub playerHP[bx],al
    push ax
    LOAD_ARR playerTeam,activePlayer
    call print_poke
    PRINT strHurtByStatus
    pop ax
    call print_num
    PRINTLN strDMG
    PRINT pressKey
    mov ah,08h
    int 21h
    call nl
    
    cmp playerHP[bx],0
    jg asd_ai
    call PLAYER_FAINT
asd_ai:
    LOAD_IDX activeAI
    mov al,aiStatus[bx]
    cmp al,4
    je asd_a
    cmp al,5
    jne asd_done
asd_a:
    mov al,aiMaxHP[bx]
    shr al,3
    cmp al,0
    jne asd_a1
    mov al,1
asd_a1:
    cmp al,aiHP[bx]
    jb asd_a2
    mov al,aiHP[bx]
asd_a2:
    sub aiHP[bx],al
    push ax
    LOAD_ARR aiTeam,activeAI
    call print_poke
    PRINT strHurtByStatus
    pop ax
    call print_num
    PRINTLN strDMG
    PRINT pressKey
    mov ah,08h
    int 21h
    call nl
    
    cmp aiHP[bx],0
    jg asd_done
    call AI_FAINT
asd_done:
    pop bx
    pop ax
    ret
APPLY_STATUS_DAMAGE endp

DRAW_HP_BAR proc
    push ax
    push bx
    push cx
    push dx
    
    mov bl, al
    mov bh, ah
    
    cmp bh, 0    
    jne bar_safe    
    mov bh, 1
bar_safe:   
    =========== 
    mov al, bl
    mov ah, 0
    mov cl, 10
    mul cl
    mov cl, bh
    div cl
    
    mov cl, al
    
    mov ah, 02h
    mov dl, '['
    int 21h
    
    mov ch, 0
bar_loop:
    cmp ch, 10
    jge bar_done
    
    cmp ch, cl
    jge bar_empty
    
    mov dl, '#'
    int 21h
    jmp bar_next
    
bar_empty:
    mov dl, '-'
    int 21h
    
bar_next:
    inc ch
    jmp bar_loop

bar_done:
    mov dl, ']'
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
    ret
DRAW_HP_BAR endp



DRAW_UI proc
    ; ==========================================
    ; Feature 5: Battle UI & HP Bar Animation
    ; DONE BY: Amrin Hoque Yeana (23301091)
    ; ==========================================
    call clrscr
    PRINTLN strLine
    
    PRINT strEnemy
    LOAD_ARR aiTeam,activeAI
    call print_poke
    call nl
    
    PRINT strHP
    LOAD_ARR aiHP,activeAI
    mov bl, al
    call print_num
    PRINT strSlash
    LOAD_ARR aiMaxHP,activeAI
    call print_num
    
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    LOAD_ARR aiHP,activeAI
    mov dl, al
    LOAD_ARR aiMaxHP,activeAI
    mov ah, al
    mov al, dl
    call DRAW_HP_BAR
    call nl
    call nl 
    
    PRINT strYou
    LOAD_ARR playerTeam,activePlayer
    call print_poke
    call nl
    
    PRINT strHP
    LOAD_ARR playerHP,activePlayer
    mov bl, al
    call print_num
    PRINT strSlash
    LOAD_ARR playerMaxHP,activePlayer
    call print_num
    
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    LOAD_ARR playerHP,activePlayer
    mov dl, al
    LOAD_ARR playerMaxHP,activePlayer
    mov ah, al
    mov al, dl
    call DRAW_HP_BAR
    call nl
    
    PRINTLN strLine
    call SHOW_MOVES
    ret
DRAW_UI endp




SHOW_MOVES proc
    push ax
    push bx
    push cx
    push si
    push di
    
    LOAD_IDX activePlayer
    mov al,playerTeam[bx]
    mov cl,4
    mul cl
    mov si,ax
    
    mov al,activePlayer
    mov cl,4
    mul cl
    mov di,ax
    
    mov cx,0

sm_loop_new:
    push cx
    
    mov ah, 02h
    mov dl, cl
    add dl, '1'
    int 21h
    mov dl, ')'
    int 21h
    mov dl, ' '
    int 21h
    
    mov ax, si
    add ax, cx
    add ax, ax
    mov bx, ax
    mov dx, mNames[bx]
    call pstr
    
    mov ah, 02h
    mov dl, '['
    int 21h
    mov dl, 'P'
    int 21h
    mov dl, 'P'
    int 21h
    mov dl, ':'
    int 21h
    
    mov bx, di
    add bx, cx
    mov al, playerPP[bx]
    call print_num
    
    mov ah, 02h
    mov dl, ']'
    int 21h
    
    call nl
    
    pop cx
    inc cx
    cmp cx, 4
    jl sm_loop_new
    
    mov ah, 02h
    mov dl, '5'
    int 21h
    mov dl, ')'
    int 21h
    mov dl, ' '
    int 21h
    
    mov dl, 'H'
    int 21h
    mov dl, 'e'
    int 21h
    mov dl, 'a'
    int 21h
    mov dl, 'l'
    int 21h
    
    LOAD_IDX activePlayer
    cmp playerItemUsed[bx],1
    jne sm_opt_switch
    
    mov dl, ' '
    int 21h
    mov dl, '('
    int 21h
    mov dl, 'X'
    int 21h
    mov dl, ')'
    int 21h

sm_opt_switch:
    call nl
    
    mov ah, 02h
    mov dl, '6'
    int 21h
    mov dl, ')'
    int 21h
    mov dl, ' '
    int 21h
    mov dl, 'S'
    int 21h
    mov dl, 'w'
    int 21h
    mov dl, 'i'
    int 21h
    mov dl, 't'
    int 21h
    mov dl, 'c'
    int 21h
    mov dl, 'h'
    int 21h
    
    call nl
    PRINTLN strLine
    
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
SHOW_MOVES endp

PLAYER_TURN proc
    mov bl,activePlayer
    mov cl,0
    call CHECK_STATUS
    cmp al,0
    je pt_done
pt_in:
    PRINT strPick
    mov ah,01h
    int 21h
    cmp al,'1'
    jb pt_inv
    cmp al,'4'
    jle pt_mv
    cmp al,'5'
    je pt_heal
    cmp al,'6'
    je pt_switch
    jmp pt_inv
pt_mv:
    sub al,'1'
    mov cl,al
    LOAD_IDX activePlayer
    mov al,bl
    push cx
    mov cl,4
    mul cl
    pop cx
    mov ch,0
    add ax,cx
    mov bx,ax
    cmp playerPP[bx],0
    je pt_inv
    dec playerPP[bx]
    PRINTLN strLine
    PRINTLN strPlayerAct
    mov al,cl
    mov ah,0
    call DO_MOVE
    jmp pt_done
pt_heal:
    LOAD_IDX activePlayer
    cmp playerItemUsed[bx],1
    je pt_inv
    mov playerItemUsed[bx],1
    mov al,playerHP[bx]
    add al,10
    cmp al,playerMaxHP[bx]
    jle pt_sh
    mov al,playerMaxHP[bx]
pt_sh:
    mov playerHP[bx],al
    PRINTLN strLine
    PRINTLN strPlayerAct
    PRINTLN strHeal
    jmp pt_done
pt_switch:
    call nl
    PRINT strSwitch
    mov ah,01h
    int 21h
    cmp al,'1'
    jb pt_inv
    cmp al,'3'
    jg pt_inv
    sub al,'1'
    cmp al,activePlayer
    je pt_inv
    LOAD_IDX al
    cmp playerHP[bx],0
    je pt_inv
    je pt_inv
    PRINTLN strLine
    PRINTLN strPlayerAct
    mov activePlayer,al
    call nl
    lea dx,strGo
    call pstr
    mov bl,activePlayer
    mov bh,0
    mov al,playerTeam[bx]
    call print_poke
    call nl
    jmp pt_done
pt_inv:
    call nl
    lea dx,invalidMsg
    call pstr
    call nl
    jmp pt_in
pt_done:
    ret
PLAYER_TURN endp

AI_TURN proc
    push ax
    push bx
    push cx
    push si
    push di
    PRINTLN strAIAct
    mov bl,activeAI
    mov cl,1
    call CHECK_STATUS
    cmp al,0
    je at_done
    LOAD_IDX activeAI
    mov al,aiMaxHP[bx]
    mov cl,30
    mul cl
    mov cl,100
    div cl
    mov cl,al
    LOAD_IDX activeAI
    mov al,aiHP[bx]
    cmp al,cl
    jg at_atk
    cmp aiItemUsed[bx],1
    je at_atk
    mov aiItemUsed[bx],1
    mov al,aiHP[bx]
    add al,10
    cmp al,aiMaxHP[bx]
    jle at_sh
    mov al,aiMaxHP[bx]
at_sh:
    mov aiHP[bx],al
    call nl
    PRINT strHeal
    jmp at_done
at_atk:
    LOAD_IDX activeAI
    mov al,aiTeam[bx]
    mov cl,4
    mul cl
    mov si,ax
    mov al,activeAI
    mov cl,4
    mul cl
    mov di,ax

at_rnd:
    push cx
    push dx
    push si
    push di
    mov ah,0
    int 1Ah
    mov ax,dx
    mov dx,0
    mov cx,4
    div cx
    
    mov bl,dl
    mov bh,0
    and bl,03h      
    pop di
    pop si
    pop dx
    pop cx
    
    push bx
    add bx,di
    cmp aiPP[bx],0
    pop bx
    je at_rnd 

    push bx
    mov cl,bl
    mov ch,0
    mov bx,di
    add bx,cx
    dec aiPP[bx]
    pop bx
    
    mov al,bl
    mov ah,1
    call DO_MOVE

at_done:
    PRINTLN strLine
    PRINT pressKey
    mov ah,08h
    int 21h
    call nl
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
AI_TURN endp

DO_MOVE proc
    ; ==========================================
    ; Feature 4: Move System with Type Effectiveness
    ; DONE BY: Farhan Zarif (23301692)
    ; ==========================================
    push ax
    push bx
    push cx
    push dx
    push si
    mov si,ax
    call nl
    mov ax,si
    cmp ah,0
    jne dm_ai
    LOAD_ARR playerTeam,activePlayer
    jmp dm_nm
dm_ai:
    LOAD_ARR aiTeam,activeAI
dm_nm:
    call print_poke
    PRINT strUsed
    mov ax,si
    cmp ah,0
    jne dm_ai2
    LOAD_ARR playerTeam,activePlayer
    jmp dm_calc
dm_ai2:
    LOAD_ARR aiTeam,activeAI
dm_calc:
    mov cl,4
    mul cl
    mov bx,ax
    mov ax,si
    mov ah,0
    add bx,ax
    push bx
    add bx,bx
    mov dx,mNames[bx]
    call pstr
    call nl
    pop bx
    
    call CHECK_ACCURACY
    cmp al,0
    je dm_done
    
    mov al,mFlags[bx]
    test al,01h
    jz dm_dmg
    
    mov al,mStatusType[bx]
    cmp al,0
    je dm_done
    cmp al,3
    je dm_rest
    
    mov dx,si
    cmp dh,0
    jne dm_stat_pl
    LOAD_IDX activeAI
    cmp aiStatus[bx],0
    jne dm_stat_fail
    mov aiStatus[bx],al
    mov aiStatusTurns[bx],3
    push ax
    LOAD_ARR aiTeam, activeAI
    call print_poke
    pop ax
    jmp dm_stat_msg
dm_stat_pl:
    LOAD_IDX activePlayer
    cmp playerStatus[bx],0
    jne dm_stat_fail
    mov playerStatus[bx],al
    mov playerStatusTurns[bx],3
    push ax
    LOAD_ARR playerTeam, activePlayer
    call print_poke
    pop ax
dm_stat_msg:
    cmp al,1
    jne dm_s2
    lea dx,strParalyzed
    jmp dm_smsg
dm_s2:
    cmp al,2
    jne dm_s4
    lea dx,strAsleep
    jmp dm_smsg
dm_s4:
    cmp al,4
    jne dm_s5
    lea dx,strPoisoned
    jmp dm_smsg
dm_s5:
    lea dx,strBurned
dm_smsg:
    call pstr
    call nl
    jmp dm_done
dm_stat_fail:
    PRINTLN strFailed
    jmp dm_done
    
dm_rest:
    mov dx,si
    cmp dh,0
    jne dm_rest_ai
    mov bl,activePlayer
    mov bh,0
    mov al,playerMaxHP[bx]
    shr al,1
    add al,playerHP[bx]
    cmp al,playerMaxHP[bx]
    jle dm_rh
    mov al,playerMaxHP[bx]
dm_rh:
    mov playerHP[bx],al
    mov playerStatus[bx],3
    lea dx,strRested
    call pstr
    call nl
    jmp dm_done
dm_rest_ai:
    LOAD_IDX activeAI
    mov al,aiMaxHP[bx]
    shr al,1
    add al,aiHP[bx]
    cmp al,aiMaxHP[bx]
    jbe dm_rha
    mov al,aiMaxHP[bx]
dm_rha:
    mov aiHP[bx],al
    mov aiStatus[bx],3
    PRINTLN strRested
    jmp dm_done
    
dm_dmg:
    push bx
    mov dl,mPower[bx]
    mov dh,mType[bx]
    mov ax,si
    cmp ah,0
    jne dm_pd
    push dx
    LOAD_IDX activeAI
    mov al,aiTeam[bx]
    mov ah,0
    mov bx,ax
    mov cl,pType[bx]
    pop dx
    jmp dm_eff
dm_pd:
    push dx
    LOAD_IDX activePlayer
    mov al,playerTeam[bx]
    mov ah,0
    mov bx,ax
    mov cl,pType[bx]
    pop dx
dm_eff:
    push dx
    mov al,dh
    mov ah,cl
    call GET_MULT
    mov ch,al
    pop dx
    mov al,dl
    cmp ch,2
    jne dm_n2
    add al,al
    push ax
    lea dx,strSuper
    call pstr
    call nl
    pop ax
    jmp dm_app
dm_n2:
    cmp ch,0
    jne dm_app
    shr al,1
    cmp al,0
    jne dm_wk
    mov al,1
dm_wk:
    push ax
    lea dx,strWeak
    call pstr
    call nl
    pop ax
dm_app:
    push ax
    push dx
    mov ah, 0
    int 1Ah
    and dl, 0Fh
    jnz no_crit
    shl al, 1
    jnc crit_done
    mov al, 255
crit_done:
    PRINTLN strCritical
no_crit:
    pop dx
    pop ax
    mov dx,si
    cmp dh,0
    jne dm_ph
    APPLY_DAMAGE activeAI, aiHP, AI_FAINT
    jmp dm_rech
dm_ph:
    APPLY_DAMAGE activePlayer, playerHP, PLAYER_FAINT
dm_rech:
    pop bx
    mov al,mFlags[bx]
    test al,02h
    jz dm_done
    mov dx,si
    cmp dh,0
    jne dm_rech_ai
    mov bl,activePlayer
    mov bh,0
    mov playerRecharge[bx],1
    jmp dm_done
dm_rech_ai:
    mov bl,activeAI
    mov bh,0
    mov aiRecharge[bx],1
dm_done:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
DO_MOVE endp

AI_FAINT proc
    push ax
    push bx
    LOAD_ARR aiTeam,activeAI
    call print_poke
    PRINTLN strFaint
    mov bx,0
af1:
    cmp bx,3
    jge af2
    cmp aiHP[bx],0
    jg af_f
    inc bx
    jmp af1
af_f:
    mov activeAI,bl
    PRINT strGo
    mov al,aiTeam[bx]
    call print_poke
    call nl
af2:
    pop bx
    pop ax
    ret
AI_FAINT endp

PLAYER_FAINT proc
    push ax
    push bx
    LOAD_ARR playerTeam,activePlayer
    call print_poke
    PRINTLN strFaint
    mov bx,0
pf1:
    cmp bx,3
    jge pf2
    cmp playerHP[bx],0
    jg pf_f
    inc bx
    jmp pf1
pf_f:
    mov activePlayer,bl
    PRINT strGo
    mov al,playerTeam[bx]
    call print_poke
    call nl
pf2:
    pop bx
    pop ax
    ret
PLAYER_FAINT endp

CHECK_END proc
    push ax
    push bx
    push cx
    SUM_HP aiHP
    cmp al,0
    jne ce2
    mov battleResult,1
    jmp ce_d
ce2:
    SUM_HP playerHP
    cmp al,0
    jne ce_d
    mov battleResult,2
ce_d:
    pop cx
    pop bx
    pop ax
    ret
CHECK_END endp

end main
