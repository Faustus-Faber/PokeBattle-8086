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


playerTeamIndices db 3 dup(0)
aiTeamIndices db 3 dup(0)
playerCurrentHP db 3 dup(0)
aiCurrentHP db 3 dup(0)
playerMaximumHP db 3 dup(0)
aiMaximumHP db 3 dup(0)
playerMovePP db 12 dup(0)
aiMovePP db 12 dup(0)
playerHealUsed db 3 dup(0)
aiHealUsed db 3 dup(0)
currentPlayerPokemonIndex db 0
currentAIPokemonIndex db 0
battleOutcomeFlag db 0
aiPokemonAvailable db 6 dup(1)
aiTypeAdvantageScores db 6 dup(0)

playerStatusCondition db 3 dup(0)
aiStatusCondition db 3 dup(0)
playerStatusDuration db 3 dup(0)
aiStatusDuration db 3 dup(0)
playerRechargeFlag db 3 dup(0)
aiRechargeFlag db 3 dup(0)


typeEffectivenessMatrix db 1,1,1,1,1  
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

SET_INDEX_REGISTER MACRO var
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

LOAD_ARRAY_ELEMENT MACRO arr,idx
    SET_INDEX_REGISTER idx
    mov al,arr[bx]
ENDM

SUM_TEAM_HP MACRO arr
    LOCAL loop_lbl
    mov cx,3
    mov bx,0
    mov al,0
    loop_lbl:
    add al,arr[bx]
    inc bx
    loop loop_lbl
ENDM

RESET_ARRAY_VALUES MACRO arr,val,count
    LOCAL loop_lbl
    mov cx,count
    mov si,0
    lea bx,arr
    loop_lbl:
    mov byte ptr [bx+si],val
    inc si
    loop loop_lbl
ENDM


ADD_WITH_OVERFLOW_CHECK MACRO dest, val, maxval
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

ADD_INDEXED_WITH_CAP MACRO arr, maxArr, val
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

APPLY_DAMAGE_TO_TARGET MACRO activeIdx, hpArr, faintProc
    LOCAL skip_dmg, done_dmg
    SET_INDEX_REGISTER activeIdx
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
    call EXECUTE_BATTLE_SEQUENCE
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
EXECUTE_BATTLE_SEQUENCE proc
    ; ==========================================
    ; Feature 3: Turn-Based Battle Engine
    ; DONE BY: Farhan Zarif (23301692)
    ; ==========================================
    call INITIALIZE_BATTLE_STATE
    call AI_SELECT_COUNTER_TEAM
    mov currentPlayerPokemonIndex,0
    mov currentAIPokemonIndex,0
    mov battleOutcomeFlag,0
main_battle_loop:
    call CHECK_BATTLE_END_CONDITION
    cmp battleOutcomeFlag,0
    jne battle_concluded
    call DRAW_UI
    mov bl,currentPlayerPokemonIndex
    mov bh,0
    mov al,playerTeamIndices[bx]
    mov ah,0
    mov bx,ax
    mov cl,pSpeed[bx]
    mov bl,currentAIPokemonIndex
    mov bh,0
    mov al,aiTeamIndices[bx]
    mov ah,0
    mov bx,ax
    mov ch,pSpeed[bx]
    cmp cl,ch
    jb ai_acts_first
    
    mov al, currentAIPokemonIndex
    push ax
    call EXECUTE_PLAYER_TURN
    call CHECK_BATTLE_END_CONDITION
    cmp battleOutcomeFlag,0
    jne cleanup_stack_and_end
    pop ax
    cmp al, currentAIPokemonIndex
    jne main_battle_loop
    
    call EXECUTE_AI_TURN
    call APPLY_POISON_BURN_DAMAGE
    call CHECK_BATTLE_END_CONDITION
    jmp main_battle_loop

cleanup_stack_and_end:
    pop ax
    jmp battle_concluded
ai_acts_first:
    mov al, currentPlayerPokemonIndex
    push ax
    call EXECUTE_AI_TURN
    call CHECK_BATTLE_END_CONDITION
    cmp battleOutcomeFlag,0
    jne cleanup_stack_and_end
    pop ax
    cmp al, currentPlayerPokemonIndex
    jne main_battle_loop

    call DRAW_UI
    call EXECUTE_PLAYER_TURN
    call APPLY_POISON_BURN_DAMAGE
    call CHECK_BATTLE_END_CONDITION
    jmp main_battle_loop
       
battle_concluded:
    call clrscr
    call nl
    lea dx,strLine
    call pstr
    call nl
    
    cmp battleOutcomeFlag,1
    jne display_loss_result

    inc playerScore
    inc roundCount
    inc winStreak
    
    mov al, winStreak
    cmp al, bestStreak
    jle skip_best_streak_update
    mov bestStreak, al
skip_best_streak_update:
    
    lea dx,strWin
    jmp display_final_stats

display_loss_result:
    inc aiScore
    inc roundCount
    mov winStreak, 0
    lea dx,strLose

display_final_stats:
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
    je skip_streak_message
    
    lea dx, strCurrentStreak
    call pstr
    mov al, winStreak
    call print_num
    call nl

skip_streak_message:
    =======

    lea dx,strLine
    call pstr
    call nl
    lea dx,pressKey
    call pstr
    mov ah,01h
    int 21h
    ret
EXECUTE_BATTLE_SEQUENCE endp

INITIALIZE_BATTLE_STATE proc
    push ax
    push bx
    push cx
    push si
    mov cx,3
    mov si,0
copy_selection_loop:
    mov al,selectedArray[si]
    sub al,'1'
    mov playerTeamIndices[si],al
    inc si
    loop copy_selection_loop
    mov cx,3
    mov si,0
init_player_stats_loop:
    mov bl,playerTeamIndices[si]
    mov bh,0
    mov al,pMaxHP[bx]
    mov playerCurrentHP[si],al
    mov playerMaximumHP[si],al
    mov playerHealUsed[si],0
    mov playerRechargeFlag[si],0
    push cx
    mov al,bl
    mov cl,4
    mul cl
    mov di,ax
    mov ax,si
    mul cl
    mov bx,ax
    mov cx,4
copy_pp_values_loop:
    mov al,mPPMax[di]
    mov playerMovePP[bx],al
    inc di
    inc bx
    loop copy_pp_values_loop
    pop cx
    inc si
    loop init_player_stats_loop
    RESET_ARRAY_VALUES aiPokemonAvailable, 1, 6
    mov cx,3
    mov si,0
mark_player_picks_unavail:
    mov bl,playerTeamIndices[si]
    mov bh,0
    mov aiPokemonAvailable[bx],0
    inc si
    loop mark_player_picks_unavail
    RESET_ARRAY_VALUES playerStatusCondition, 0, 3
    RESET_ARRAY_VALUES aiStatusCondition, 0, 3
    RESET_ARRAY_VALUES playerStatusDuration, 0, 3
    RESET_ARRAY_VALUES aiStatusDuration, 0, 3
    pop si
    pop cx
    pop bx
    pop ax
    ret
INITIALIZE_BATTLE_STATE endp

AI_SELECT_COUNTER_TEAM proc
    push ax
    push bx
    push cx
    push si
    push di
    mov si,0
score_all_pokemon_loop:
    cmp si,6
    jge select_best_three
    cmp aiPokemonAvailable[si],0
    je next_pokemon_to_score
    mov di,0
    mov dl,0
calc_type_advantage_loop:
    cmp di,3
    jge store_pokemon_score
    mov bx,si
    mov al,pType[bx]
    mov bl,playerTeamIndices[di]
    mov bh,0
    mov ah,pType[bx]
    call GET_TYPE_EFFECTIVENESS
    add dl,al
    inc di
    jmp calc_type_advantage_loop
store_pokemon_score:
    mov aiTypeAdvantageScores[si],dl
next_pokemon_to_score:
    inc si
    jmp score_all_pokemon_loop
select_best_three:
    call FIND_HIGHEST_SCORE_POKEMON
    mov aiTeamIndices[0],al
    mov bl,al
    mov bh,0
    mov aiPokemonAvailable[bx],0
    call FIND_HIGHEST_SCORE_POKEMON
    mov aiTeamIndices[1],al
    mov bl,al
    mov bh,0
    mov aiPokemonAvailable[bx],0
    call FIND_HIGHEST_SCORE_POKEMON
    mov aiTeamIndices[2],al
    mov cx,3
    mov si,0
init_ai_stats_loop:
    mov bl,aiTeamIndices[si]
    mov bh,0
    mov al,pMaxHP[bx]
    mov aiCurrentHP[si],al
    mov aiMaximumHP[si],al
    mov aiHealUsed[si],0
    mov aiRechargeFlag[si],0
    push cx
    mov al,bl
    mov cl,4
    mul cl
    mov di,ax
    mov ax,si
    mul cl
    mov bx,ax
    mov cx,4
copy_ai_pp_loop:
    mov al,mPPMax[di]
    mov aiMovePP[bx],al
    inc di
    inc bx
    loop copy_ai_pp_loop
    pop cx
    inc si
    loop init_ai_stats_loop
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
AI_SELECT_COUNTER_TEAM endp

FIND_HIGHEST_SCORE_POKEMON proc
    push bx
    push cx
    mov cx,6
    mov bx,0
    mov dl,0
    mov dh,0
find_best_loop:
    cmp aiPokemonAvailable[bx],0
    je next_candidate
    mov al,aiTypeAdvantageScores[bx]
    cmp al,dl
    jle next_candidate
    mov dl,al
    mov dh,bl
next_candidate:
    inc bx
    loop find_best_loop
    mov al,dh
    pop cx
    pop bx
    ret
FIND_HIGHEST_SCORE_POKEMON endp

GET_TYPE_EFFECTIVENESS proc
    push bx
    push cx
    mov cl,ah
    mov ah,0
    mov bl,5
    mul bl
    add al,cl
    mov bx,ax
    mov al,typeEffectivenessMatrix[bx]
    pop cx
    pop bx
    ret
GET_TYPE_EFFECTIVENESS endp

CHECK_STATUS_CONDITIONS proc
    push bx
    push dx
    mov bh,0
    
    cmp cl,0
    jne check_ai_recharge_flag
    cmp playerRechargeFlag[bx],1
    jne check_standard_status
    mov playerRechargeFlag[bx],0
    jmp print_recharge_message
check_ai_recharge_flag:
    cmp aiRechargeFlag[bx],1
    jne check_standard_status
    mov aiRechargeFlag[bx],0
print_recharge_message:
    push ax
    push bx
    cmp cl,0
    jne load_ai_name_for_recharge
    LOAD_ARRAY_ELEMENT playerTeamIndices,currentPlayerPokemonIndex
    jmp print_recharge_name
load_ai_name_for_recharge:
    LOAD_ARRAY_ELEMENT aiTeamIndices,currentAIPokemonIndex
print_recharge_name:
    call print_poke
    pop bx
    pop ax
    PRINTLN strRecharge
    jmp skip_turn_message
    
check_standard_status:
    cmp cl,0
    jne load_ai_status
    mov al,playerStatusCondition[bx]
    jmp evaluate_status_type
load_ai_status:
    mov al,aiStatusCondition[bx]
evaluate_status_type:
    cmp al,0
    je status_allows_action
    cmp al,3
    je handle_rest_wakeup
    cmp al,4
    jge status_allows_action
    
    cmp cl,0
    jne decrement_ai_status_turns
    dec playerStatusDuration[bx]
    cmp playerStatusDuration[bx],0
    jg skip_turn_message
    mov playerStatusCondition[bx],0
    jmp print_woke_up_message
decrement_ai_status_turns:
    dec aiStatusDuration[bx]
    cmp aiStatusDuration[bx],0
    jg skip_turn_message
    mov aiStatusCondition[bx],0
print_woke_up_message:
    push ax
    push bx
    cmp cl,0
    jne load_ai_name_wake
    LOAD_ARRAY_ELEMENT playerTeamIndices,currentPlayerPokemonIndex
    jmp print_wake_name
load_ai_name_wake:
    LOAD_ARRAY_ELEMENT aiTeamIndices,currentAIPokemonIndex
print_wake_name:
    call print_poke
    pop bx
    pop ax
    PRINTLN strWokeUp
    jmp status_allows_action
    
handle_rest_wakeup:
    cmp cl,0
    jne clear_ai_rest_status
    mov playerStatusCondition[bx],0
    jmp print_sleeping_message
clear_ai_rest_status:
    mov aiStatusCondition[bx],0
print_sleeping_message:
    push ax
    push bx
    cmp cl,0
    jne load_ai_name_sleep
    LOAD_ARRAY_ELEMENT playerTeamIndices,currentPlayerPokemonIndex
    jmp print_sleep_name
load_ai_name_sleep:
    LOAD_ARRAY_ELEMENT aiTeamIndices,currentAIPokemonIndex
print_sleep_name:
    call print_poke
    pop bx
    pop ax
    PRINTLN strIsSleeping
    jmp skip_turn_message

skip_turn_message:
    
    
    push ax
    push bx
    cmp cl,0
    jne load_ai_cant_move
    LOAD_ARRAY_ELEMENT playerTeamIndices,currentPlayerPokemonIndex
    jmp print_cant_move_name
load_ai_cant_move:
    LOAD_ARRAY_ELEMENT aiTeamIndices,currentAIPokemonIndex
print_cant_move_name:
    call print_poke
    pop bx
    pop ax
    PRINTLN strCantMove
    mov al,0
    jmp status_check_complete
status_allows_action:
    mov al,1
status_check_complete:
    pop dx
    pop bx
    ret
CHECK_STATUS_CONDITIONS endp

ROLL_ACCURACY_CHECK proc
    push cx
    push dx
    mov al,mAccuracy[bx]
    cmp al,255
    je accuracy_check_passed
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
    jle accuracy_check_passed
    lea dx,strMissed
    call pstr
    call nl
    mov al,0
    jmp accuracy_check_complete
accuracy_check_passed:
    mov al,1
accuracy_check_complete:
    pop dx
    pop cx
    ret
ROLL_ACCURACY_CHECK endp

APPLY_POISON_BURN_DAMAGE proc
    push ax
    push bx
    SET_INDEX_REGISTER currentPlayerPokemonIndex
    mov al,playerStatusCondition[bx]
    cmp al,4
    je apply_player_status_dmg
    cmp al,5
    jne check_ai_status_damage
apply_player_status_dmg:
    mov al,playerMaximumHP[bx]
    shr al,3
    cmp al,0
    jne player_status_min_damage
    mov al,1
player_status_min_damage:
    cmp al,playerCurrentHP[bx]
    jb player_status_cap_damage
    mov al,playerCurrentHP[bx]
player_status_cap_damage:
    sub playerCurrentHP[bx],al
    push ax
    LOAD_ARRAY_ELEMENT playerTeamIndices,currentPlayerPokemonIndex
    call print_poke
    PRINT strHurtByStatus
    pop ax
    call print_num
    PRINTLN strDMG
    PRINT pressKey
    mov ah,08h
    int 21h
    call nl
    
    cmp playerCurrentHP[bx],0
    jg check_ai_status_damage
    call HANDLE_PLAYER_POKEMON_FAINT
check_ai_status_damage:
    SET_INDEX_REGISTER currentAIPokemonIndex
    mov al,aiStatusCondition[bx]
    cmp al,4
    je apply_ai_status_dmg
    cmp al,5
    jne status_damage_complete
apply_ai_status_dmg:
    mov al,aiMaximumHP[bx]
    shr al,3
    cmp al,0
    jne ai_status_min_damage
    mov al,1
ai_status_min_damage:
    cmp al,aiCurrentHP[bx]
    jb ai_status_cap_damage
    mov al,aiCurrentHP[bx]
ai_status_cap_damage:
    sub aiCurrentHP[bx],al
    push ax
    LOAD_ARRAY_ELEMENT aiTeamIndices,currentAIPokemonIndex
    call print_poke
    PRINT strHurtByStatus
    pop ax
    call print_num
    PRINTLN strDMG
    PRINT pressKey
    mov ah,08h
    int 21h
    call nl
    
    cmp aiCurrentHP[bx],0
    jg status_damage_complete
    call HANDLE_AI_POKEMON_FAINT
status_damage_complete:
    pop bx
    pop ax
    ret
APPLY_POISON_BURN_DAMAGE endp

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
    LOAD_ARRAY_ELEMENT aiTeamIndices,currentAIPokemonIndex
    call print_poke
    call nl
    
    PRINT strHP
    LOAD_ARRAY_ELEMENT aiCurrentHP,currentAIPokemonIndex
    mov bl, al
    call print_num
    PRINT strSlash
    LOAD_ARRAY_ELEMENT aiMaximumHP,currentAIPokemonIndex
    call print_num
    
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    LOAD_ARRAY_ELEMENT aiCurrentHP,currentAIPokemonIndex
    mov dl, al
    LOAD_ARRAY_ELEMENT aiMaximumHP,currentAIPokemonIndex
    mov ah, al
    mov al, dl
    call DRAW_HP_BAR
    call nl
    call nl 
    
    PRINT strYou
    LOAD_ARRAY_ELEMENT playerTeamIndices,currentPlayerPokemonIndex
    call print_poke
    call nl
    
    PRINT strHP
    LOAD_ARRAY_ELEMENT playerCurrentHP,currentPlayerPokemonIndex
    mov bl, al
    call print_num
    PRINT strSlash
    LOAD_ARRAY_ELEMENT playerMaximumHP,currentPlayerPokemonIndex
    call print_num
    
    mov ah, 02h
    mov dl, ' '
    int 21h
    
    LOAD_ARRAY_ELEMENT playerCurrentHP,currentPlayerPokemonIndex
    mov dl, al
    LOAD_ARRAY_ELEMENT playerMaximumHP,currentPlayerPokemonIndex
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
    
    SET_INDEX_REGISTER currentPlayerPokemonIndex
    mov al,playerTeamIndices[bx]
    mov cl,4
    mul cl
    mov si,ax
    
    mov al,currentPlayerPokemonIndex
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
    mov al, playerMovePP[bx]
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
    
    SET_INDEX_REGISTER currentPlayerPokemonIndex
    cmp playerHealUsed[bx],1
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

EXECUTE_PLAYER_TURN proc
    mov bl,currentPlayerPokemonIndex
    mov cl,0
    call CHECK_STATUS_CONDITIONS
    cmp al,0
    je player_turn_complete
player_input_loop:
    PRINT strPick
    mov ah,01h
    int 21h
    cmp al,'1'
    jb invalid_player_input
    cmp al,'4'
    jle player_use_move
    cmp al,'5'
    je player_use_heal
    cmp al,'6'
    je player_switch_pokemon
    jmp invalid_player_input
player_use_move:
    sub al,'1'
    mov cl,al
    SET_INDEX_REGISTER currentPlayerPokemonIndex
    mov al,bl
    push cx
    mov cl,4
    mul cl
    pop cx
    mov ch,0
    add ax,cx
    mov bx,ax
    cmp playerMovePP[bx],0
    je invalid_player_input
    dec playerMovePP[bx]
    call nl
    PRINTLN strLine
    PRINTLN strPlayerAct
    mov al,cl
    mov ah,0
    call EXECUTE_MOVE_ATTACK
    jmp player_turn_complete
player_use_heal:
    SET_INDEX_REGISTER currentPlayerPokemonIndex
    cmp playerHealUsed[bx],1
    je invalid_player_input
    mov playerHealUsed[bx],1
    mov al,playerCurrentHP[bx]
    add al,10
    cmp al,playerMaximumHP[bx]
    jle apply_player_heal
    mov al,playerMaximumHP[bx]
apply_player_heal:
    mov playerCurrentHP[bx],al
    call nl
    PRINTLN strLine
    PRINTLN strPlayerAct
    PRINTLN strHeal
    jmp player_turn_complete
player_switch_pokemon:
    call nl
    PRINT strSwitch
    mov ah,01h
    int 21h
    cmp al,'1'
    jb invalid_player_input
    cmp al,'3'
    jg invalid_player_input
    sub al,'1'
    cmp al,currentPlayerPokemonIndex
    je invalid_player_input
    SET_INDEX_REGISTER al
    cmp playerCurrentHP[bx],0
    je invalid_player_input
    je invalid_player_input
    call nl
    PRINTLN strLine
    PRINTLN strPlayerAct
    mov currentPlayerPokemonIndex,al
    call nl
    lea dx,strGo
    call pstr
    mov bl,currentPlayerPokemonIndex
    mov bh,0
    mov al,playerTeamIndices[bx]
    call print_poke
    call nl
    jmp player_turn_complete
invalid_player_input:
    call nl
    lea dx,invalidMsg
    call pstr
    call nl
    jmp player_input_loop
player_turn_complete:
    ret
EXECUTE_PLAYER_TURN endp

EXECUTE_AI_TURN proc
    push ax
    push bx
    push cx
    push si
    push di
    PRINTLN strAIAct
    mov bl,currentAIPokemonIndex
    mov cl,1
    call CHECK_STATUS_CONDITIONS
    cmp al,0
    je ai_turn_complete
    SET_INDEX_REGISTER currentAIPokemonIndex
    mov al,aiMaximumHP[bx]
    mov cl,30
    mul cl
    mov cl,100
    div cl
    mov cl,al
    SET_INDEX_REGISTER currentAIPokemonIndex
    mov al,aiCurrentHP[bx]
    cmp al,cl
    jg ai_choose_attack
    cmp aiHealUsed[bx],1
    je ai_choose_attack
    mov aiHealUsed[bx],1
    mov al,aiCurrentHP[bx]
    add al,10
    cmp al,aiMaximumHP[bx]
    jle ai_apply_heal
    mov al,aiMaximumHP[bx]
ai_apply_heal:
    mov aiCurrentHP[bx],al
    call nl
    PRINT strHeal
    jmp ai_turn_complete
ai_choose_attack:
    SET_INDEX_REGISTER currentAIPokemonIndex
    mov al,aiTeamIndices[bx]
    mov cl,4
    mul cl
    mov si,ax
    mov al,currentAIPokemonIndex
    mov cl,4
    mul cl
    mov di,ax

ai_random_move_select:
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
    cmp aiMovePP[bx],0
    pop bx
    je ai_random_move_select 

    push bx
    mov cl,bl
    mov ch,0
    mov bx,di
    add bx,cx
    dec aiMovePP[bx]
    pop bx
    
    mov al,bl
    mov ah,1
    call EXECUTE_MOVE_ATTACK

ai_turn_complete:
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
EXECUTE_AI_TURN endp

EXECUTE_MOVE_ATTACK proc
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
    jne load_ai_attacker
    LOAD_ARRAY_ELEMENT playerTeamIndices,currentPlayerPokemonIndex
    jmp print_attacker_name
load_ai_attacker:
    LOAD_ARRAY_ELEMENT aiTeamIndices,currentAIPokemonIndex
print_attacker_name:
    call print_poke
    PRINT strUsed
    mov ax,si
    cmp ah,0
    jne get_ai_pokemon_for_calc
    LOAD_ARRAY_ELEMENT playerTeamIndices,currentPlayerPokemonIndex
    jmp calculate_move_index
get_ai_pokemon_for_calc:
    LOAD_ARRAY_ELEMENT aiTeamIndices,currentAIPokemonIndex
calculate_move_index:
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
    
    call ROLL_ACCURACY_CHECK
    cmp al,0
    je move_execution_complete
    
    mov al,mFlags[bx]
    test al,01h
    jz calculate_damage
    
    mov al,mStatusType[bx]
    cmp al,0
    je move_execution_complete
    cmp al,3
    je execute_rest_heal
    
    mov dx,si
    cmp dh,0
    jne apply_status_to_player
    SET_INDEX_REGISTER currentAIPokemonIndex
    cmp aiStatusCondition[bx],0
    jne status_already_applied
    mov aiStatusCondition[bx],al
    mov aiStatusDuration[bx],3
    push ax
    LOAD_ARRAY_ELEMENT aiTeamIndices, currentAIPokemonIndex
    call print_poke
    pop ax
    jmp print_status_message
apply_status_to_player:
    SET_INDEX_REGISTER currentPlayerPokemonIndex
    cmp playerStatusCondition[bx],0
    jne status_already_applied
    mov playerStatusCondition[bx],al
    mov playerStatusDuration[bx],3
    push ax
    LOAD_ARRAY_ELEMENT playerTeamIndices, currentPlayerPokemonIndex
    call print_poke
    pop ax
print_status_message:
    cmp al,1
    jne check_if_sleep_status
    lea dx,strParalyzed
    jmp output_status_string
check_if_sleep_status:
    cmp al,2
    jne check_if_poison_status
    lea dx,strAsleep
    jmp output_status_string
check_if_poison_status:
    cmp al,4
    jne default_burn_status
    lea dx,strPoisoned
    jmp output_status_string
default_burn_status:
    lea dx,strBurned
output_status_string:
    call pstr
    call nl
    jmp move_execution_complete
status_already_applied:
    PRINTLN strFailed
    jmp move_execution_complete
    
execute_rest_heal:
    mov dx,si
    cmp dh,0
    jne rest_heal_ai
    mov bl,currentPlayerPokemonIndex
    mov bh,0
    mov al,playerMaximumHP[bx]
    shr al,1
    add al,playerCurrentHP[bx]
    cmp al,playerMaximumHP[bx]
    jle apply_player_rest_heal
    mov al,playerMaximumHP[bx]
apply_player_rest_heal:
    mov playerCurrentHP[bx],al
    mov playerStatusCondition[bx],3
    lea dx,strRested
    call pstr
    call nl
    jmp move_execution_complete
rest_heal_ai:
    SET_INDEX_REGISTER currentAIPokemonIndex
    mov al,aiMaximumHP[bx]
    shr al,1
    add al,aiCurrentHP[bx]
    cmp al,aiMaximumHP[bx]
    jbe apply_ai_rest_heal
    mov al,aiMaximumHP[bx]
apply_ai_rest_heal:
    mov aiCurrentHP[bx],al
    mov aiStatusCondition[bx],3
    PRINTLN strRested
    jmp move_execution_complete
    
calculate_damage:
    push bx
    mov dl,mPower[bx]
    mov dh,mType[bx]
    mov ax,si
    cmp ah,0
    jne get_player_defender_type
    push dx
    SET_INDEX_REGISTER currentAIPokemonIndex
    mov al,aiTeamIndices[bx]
    mov ah,0
    mov bx,ax
    mov cl,pType[bx]
    pop dx
    jmp lookup_type_effectiveness
get_player_defender_type:
    push dx
    SET_INDEX_REGISTER currentPlayerPokemonIndex
    mov al,playerTeamIndices[bx]
    mov ah,0
    mov bx,ax
    mov cl,pType[bx]
    pop dx
lookup_type_effectiveness:
    push dx
    mov al,dh
    mov ah,cl
    call GET_TYPE_EFFECTIVENESS
    mov ch,al
    pop dx
    mov al,dl
    cmp ch,2
    jne check_if_not_effective
    add al,al
    push ax
    lea dx,strSuper
    call pstr
    call nl
    pop ax
    jmp apply_final_damage
check_if_not_effective:
    cmp ch,0
    jne apply_final_damage
    shr al,1
    cmp al,0
    jne apply_not_effective_min
    mov al,1
apply_not_effective_min:
    push ax
    lea dx,strWeak
    call pstr
    call nl
    pop ax
apply_final_damage:
    push ax
    push dx
    mov ah, 0
    int 1Ah
    and dl, 0Fh
    jnz no_critical_hit
    shl al, 1
    jnc critical_hit_applied
    mov al, 255
critical_hit_applied:
    PRINTLN strCritical
no_critical_hit:
    pop dx
    pop ax
    mov dx,si
    cmp dh,0
    jne damage_player_pokemon
    APPLY_DAMAGE_TO_TARGET currentAIPokemonIndex, aiCurrentHP, HANDLE_AI_POKEMON_FAINT
    jmp check_recharge_needed
damage_player_pokemon:
    APPLY_DAMAGE_TO_TARGET currentPlayerPokemonIndex, playerCurrentHP, HANDLE_PLAYER_POKEMON_FAINT
check_recharge_needed:
    pop bx
    mov al,mFlags[bx]
    test al,02h
    jz move_execution_complete
    mov dx,si
    cmp dh,0
    jne set_ai_recharge_flag
    mov bl,currentPlayerPokemonIndex
    mov bh,0
    mov playerRechargeFlag[bx],1
    jmp move_execution_complete
set_ai_recharge_flag:
    mov bl,currentAIPokemonIndex
    mov bh,0
    mov aiRechargeFlag[bx],1
move_execution_complete:
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
EXECUTE_MOVE_ATTACK endp

HANDLE_AI_POKEMON_FAINT proc
    push ax
    push bx
    LOAD_ARRAY_ELEMENT aiTeamIndices,currentAIPokemonIndex
    call print_poke
    PRINTLN strFaint
    mov bx,0
find_next_ai_pokemon:
    cmp bx,3
    jge ai_faint_complete
    cmp aiCurrentHP[bx],0
    jg switch_to_alive_ai
    inc bx
    jmp find_next_ai_pokemon
switch_to_alive_ai:
    mov currentAIPokemonIndex,bl
    PRINT strGo
    mov al,aiTeamIndices[bx]
    call print_poke
    call nl
ai_faint_complete:
    pop bx
    pop ax
    ret
HANDLE_AI_POKEMON_FAINT endp

HANDLE_PLAYER_POKEMON_FAINT proc
    push ax
    push bx
    LOAD_ARRAY_ELEMENT playerTeamIndices,currentPlayerPokemonIndex
    call print_poke
    PRINTLN strFaint
    mov bx,0
find_next_player_pokemon:
    cmp bx,3
    jge player_faint_complete
    cmp playerCurrentHP[bx],0
    jg switch_to_alive_player
    inc bx
    jmp find_next_player_pokemon
switch_to_alive_player:
    mov currentPlayerPokemonIndex,bl
    PRINT strGo
    mov al,playerTeamIndices[bx]
    call print_poke
    call nl
player_faint_complete:
    pop bx
    pop ax
    ret
HANDLE_PLAYER_POKEMON_FAINT endp

CHECK_BATTLE_END_CONDITION proc
    push ax
    push bx
    push cx
    SUM_TEAM_HP aiCurrentHP
    cmp al,0
    jne check_player_team_hp
    mov battleOutcomeFlag,1
    jmp end_check_done
check_player_team_hp:
    SUM_TEAM_HP playerCurrentHP
    cmp al,0
    jne end_check_done
    mov battleOutcomeFlag,2
end_check_done:
    pop cx
    pop bx
    pop ax
    ret
CHECK_BATTLE_END_CONDITION endp

end main
