" ====================================================================
" DevLife v1.0, May 2013
" ========================
" 
" Small VIM game to kill time
" (c)2013 Evgueni Antonov
"
"
" SETUP:
" Just edit the value on line 34: devlifeSavePath = 'your/savegames/path/'
" Please make sure the path ends with a separator!
" Example: 'c:\proj\hal9000\' or if on Linux: '/blah/proj/hal9000/'
"
" RUN:
" :so devlife.vim
" :call RunDevLife()
"
" TO RUN WITH SHORTCUTS, ADD TO VIMRC:
" :nmap \s :so devlife.vim
" :nmap \b :call RunDevLife()
" then use \s to load the source and \b to run the game.
" You may also specify your path to devlife.vim .
"
" HOW TO PLAY:
" Just run the game. Detailed instructions are available ingame.




" ====================================================================
" SETUP: This is the default savegame path.
" Put your savegame path in between the '' chars.
" Always put a slash/backslash in the end!
let g:savegamePath = '/home/sneakypotato/.devlife/'


" Game global
let g:game = {
    \'nameShort'        : 'DevLife',
    \'nameFull'         : 'DEVELOPER''s LIFE',
    \'version'          : '1.0',
    \'authorName'       : 'Evgueni Antonov',
    \'authorContact'    : 'http://ca.linkedin.com/in/eantonoff/',
    \'versionDate'      : '2013-05-10',
    \'pathSavegame'     : g:savegamePath,
    \'whereToGet'       : 'https://github.com/StrayFeral/DevLife.git',
    \'license'          : 'http://www.gnu.org/licenses/gpl-3.0.html'
\}





" Loaded instance check
if ( exists( 'devlife_is_loaded' ) )
    call g:ppp( 'DevLife is already loaded. Loading skipped.' )
    finish
endif

let g:devlife_is_loaded = 1




" ====================================================================
" MAIN RUN: Call this to start the game.
function! RunDevLife()
    call GameInit()
    call g:ppp( 'WELCOME!' ) | call g:ppp( '' )
    call ShowIntro()
    call Main()
endfunction




" ====================================================================
" MAIN FUNCTION

" Main loop
function! Main()

    " Main loop
    let userChoice = ''
    while ( userChoice != g:commandGlobalQuit && !GotFired() )
        let userChoiceDefault = ''
        let userChoice = g:getMenuChoice( userChoiceDefault )
        
        " Processing commands
        if ( userChoice ==# 'n' )     | " NEW GAME
            call StartNewGame()
            call BackupAge( 0 )
        elseif ( userChoice ==# 'c' ) | " CLEAR SCREEN
            call g:cls()
        elseif ( userChoice ==# 'p' ) | " PLAYER STATS
            call PrintPlayer()
        elseif ( userChoice ==# 's' ) | " SAVE GAME
            if ( !GameStarted() )
                call g:ppp( 'ERROR: This command is available while in a game. Please start a new game.' )
            else
                call SaveGame()
            endif
        elseif ( userChoice ==# 'l' ) | " LOAD GAME
            call LoadGame()
        elseif ( userChoice ==# 'h' ) | " HIGHSCORES
            call ShowHighscores()
        elseif ( userChoice ==# 'c' ) | " CLEAR SCREEN
            call g:ppp( "cls" )
        elseif ( userChoice ==# '1' ) | " WORK
            if ( !GameStarted() )
                call g:ppp( 'ERROR: This command is available while in a game. Please start a new game.' )
            else
                call DoWork()
                call CalcScore()
                call PrintMgrHappyMessage()
            endif
        elseif ( userChoice ==# '3' ) | " HAVE FUN
            if ( !GameStarted() )
                call g:ppp( 'ERROR: This command is available while in a game. Please start a new game.' )
            else
                call HaveFun()
                call CalcScore()
                call PrintMgrHappyMessage()
            endif
        elseif ( userChoice ==# '2' ) | " CREATE CODE BACKUP
            if ( !GameStarted() )
                call g:ppp( 'ERROR: This command is available while in a game. Please start a new game.' )
            else
                call CreateBackup()
                "call ChangeStat( g:stats.experience, 0 )
                call CalcScore()
                call PrintMgrHappyMessage()
            endif
        elseif ( userChoice ==# '?' ) | " HELP
            call ShowHelp()
        elseif ( userChoice ==# ' ' ) | " BOSS KEY
            call ShowBossScreen()
        elseif ( userChoice ==# 'q' ) | " QUIT GAME
            if ( !ConfirmQuit() )
                let userChoice = ''
            endif
        endif
        
        if ( GameStarted() )
            call PrintGameStatus()
        endif
    endwhile

    if ( userChoice ==# 'q' )
    " END GAME
        call g:ppp( '' )
        call g:ppp( 'Thanks for playing ' . g:game.nameShort . '! You can now quit the editor.' )
        call g:ppp( '' )
    else
        " Got fired
        call g:ppp( '' )
        call g:ppp( '[GOT FIRED] Your manager asks to see you in private. When you enter the room, you see a young girl. She presents herself as a member of the Human Resources Department and gives you an envelope. You open it and you see a letter of termination of your contract. Your manager says your services are no longer needed and asks you to leave the office immediatelly. You leave the office.' )
        call g:ppp( '' )
        call ShowHighscores()
        call g:ppp( '' )
        call g:ppp( '[GAME OVER] Your game is now over. Thank you for playing!' )
        call g:ppp( '' )
    endif

    
endfunction




" ====================================================================
" WRAPPERS


" Score calculator
function! CalcScore()
    let g:player.score = g:player.fun + 
                            \g:player.motivation + 
                            \g:player.productivity + 
                            \float2nr( round( g:player.mgrHappy ) ) + 
                            \g:player.level
endfunction


" Got Lazy
function! GotLazy()
    call g:ppp( '' )
    call g:ppp( '[GOT LAZY] ' . GetLazyMessage() )
    call g:ppp( '' )
    let g:player.fun -= 5
    let g:player.motivation -= 20
    let g:player.productivity -= 20
    let g:player.mgrHappy -= 2.5
    if ( g:player.fun < 0 )
        let g:player.fun = 0
    endif
    if ( g:player.motivation < 0 )
        let g:player.motivation = 0
    endif
    if ( g:player.productivity < 0 )
        let g:player.productivity = 0
    endif
    if ( g:player.mgrHappy < 0 )
        let g:player.mgrHappy = 0
    endif
endfunction


" Got Workaholic
function! GotWorkaholic()
    call g:ppp( '' )
    call g:ppp( '[GOT WORKAHOLIC] ' . GetWorkaholicMessage() )
    call g:ppp( '' )
    let g:player.fun -= 5
    let g:player.motivation -= 20
    if ( g:player.fun < 0 )
        let g:player.fun = 0
    endif
    if ( g:player.motivation < 0 )
        let g:player.motivation = 0
    endif
endfunction


" Got fired?
function! GotFired()
    if ( GameStarted() && g:player.mgrHappy == 0 )
        return 1
    endif
    return 0
endfunction


" Pump fun gauge
function! PumpFunGauge()
    let g:funGauge += 1
    
    if ( TooMuchFun() )
        call ReleaseFunGauge()
        call ReleaseFunGauge()
        call GotLazy()
    endif
endfunction


" Release fun gauge
function! ReleaseFunGauge()
    let g:funGauge -= 1
    
    if ( g:funGauge < 0 )
        let g:funGauge = 0
    endif
endfunction


" Pump work gauge
function! PumpWorkGauge()
    let g:workGauge += 1
    
    if ( TooMuchWork() )
        call ReleaseWorkGauge()
        call ReleaseWorkGauge()
        call GotWorkaholic()
    endif
endfunction


" Release work gauge
function! ReleaseWorkGauge()
    let g:workGauge -= 1
    
    if ( g:workGauge < 0 )
        let g:workGauge = 0
    endif
endfunction


" Too much fun
function! TooMuchFun()
    if ( g:funGauge > g:funMax )
        return 1
    endif
    return 0
endfunction


" Too much work
function! TooMuchWork()
    if ( g:workGauge > g:workMax )
        return 1
    endif
    return 0
endfunction


" Intro
function! ShowIntro()
    call g:printArray( g:msgIntro )
endfunction


" Help
function! ShowHelp()
    call g:ppp( 'GAME KEYS' )
    call g:hr()
    call g:printHash( g:validCommands, 3 )
endfunction


" Boss key
function! ShowBossScreen()
    call g:printArray( g:msgBossKey )
    call getchar() | " Just waiting for any key...
endfunction


" Performing game setup
function! GameInit()
    if !empty( $DEVLIFESAVEPATH )
        g:savegamePath = $DEVLIFESAVEPATH
    endif
    let g:backupAge         = 0
    let g:funGauge          = 0
    let g:workGauge         = 0
    let g:msgHappyMaxShown  = 0
    
    " Player stats initialization
    let g:player = {
        \g:stats.name           : '*Noname*',
        \g:stats.motivation     : 0,
        \g:stats.productivity   : 0,
        \g:stats.experience     : 0,
        \g:stats.level          : 0,
        \g:stats.fun            : 0,
        \g:stats.company        : '*No company*',
        \g:stats.score          : 0,
        \g:stats.mgrHappy       : 1,
        \g:stats.title          : '',
        \g:stats.status         : g:status.gameNone
    \}
endfunction


" Print player stats
function! PrintPlayer()
    call g:ppp( 'PLAYER STATS' )
    call g:ppp( '---------------------------' )
    let offset = 15
    for key in keys( g:player )
        let val = g:player[ key ]
        let s = key
        while strlen( s ) < offset
            let s .= ' '
        endwhile
        if ( key == 'status' )
            if ( val == g:status.gameNone )
                let val = '** Game not started **'
            elseif ( val == g:status.gameOver )
                let val = '** GAME OVER **'
            elseif ( val == g:status.gameNotSaved )
                let val = '* GAME NOT SAVED'
            elseif ( val == g:status.gameSaved )
                let val = 'Game saved.'
            endif
        endif
        if ( key == g:stats.mgrHappy )
            let s .= printf( '%.2f', val )
        else
            let s .= val
        endif
        call g:ppp( s )
    endfor
endfunction


" Game check
function! GameStarted()
    if ( g:player.status == g:status.gameNone )
        return 0
    else
        return 1
    endif
endfunction


" Print game status
function! PrintGameStatus()
    let status1 = 
        \g:msgGameStatus[ g:player.status ] . 
        \' ' . g:player.name . 
        \', ' . g:player.title . 
        \' at ' . g:player.company
    let status2 = 
        \'Experience: ' . g:player.experience . 
        \' Productivity: ' . g:player.productivity .
        \' Level: ' . g:player.level . 
        \' Score: ' . g:player.score
        
    call g:ppp( '' )
    call g:ppp( '___' )
    call g:ppp( status1 )
    call g:ppp( status2 )
    call g:ppp( '' )
endfunction


" Start new game
function! StartNewGame()
    " Global variables initialization
    let g:backupAge             = 0
    let g:funGauge              = 0
    let g:workGauge             = 0
    let g:msgHappyMaxShown      = 0
    
    " Player stats initialization
    let g:player = {
        \g:stats.name           : 'Player1',
        \g:stats.motivation     : 50,
        \g:stats.productivity   : 20,
        \g:stats.experience     : 0,
        \g:stats.level          : 0,
        \g:stats.fun            : 2,
        \g:stats.company        : CompanyNameGenerator(),
        \g:stats.score          : 0,
        \g:stats.mgrHappy       : 5.00,
        \g:stats.title          : g:msgProgressDescription[ 0 ][ 0 ],
        \g:stats.status         : g:status.gameNotSaved
    \}  | " status.gameNone is 'not in a game'

    let g:player.name = g:getString( '[NEW GAME] Please enter your name (Alowed: A-z0-9_): ', g:emptyValue.reject, g:player.name, g:namesMaxLen )
    call g:ppp( '' )
    call PrintPlayer()
    call g:ppp( '' )
    call PrintWelcomeMessage()
endfunction


" Save game
function! SaveGame()
    let buf = [
        \g:player.name,
        \g:player.motivation,
        \g:player.productivity,
        \g:player.experience,
        \g:player.level,
        \g:player.fun,
        \g:player.company,
        \g:player.score,
        \printf( '%.2f', g:player.mgrHappy ),
        \g:player.title,
        \g:backupAge,
        \g:funGauge,
        \g:workGauge,
        \g:msgHappyMaxShown
    \]
    let fname = g:player.name . g:fext.savegame
    let fullPath = g:game.pathSavegame . fname
    
    let res = writefile( buf, fullPath )
    
    call g:ppp( '' )
    if ( res == -1 )
        call g:ppp( '[SAVE GAME] ERROR SAVING GAME! Cannot save your game.' )
    elseif ( res == 0 )
        call g:ppp( '[SAVE GAME] Game saved (' . fname . ').' )
        let g:player.status = g:status.gameSaved
    endif
endfunction


" Load game
function! LoadGame()
    let pName = g:getString( '[LOAD GAME] Please enter your name (Alowed: A-z0-9_): ', g:emptyValue.reject, g:player.name, g:namesMaxLen )
    call g:ppp( '' )
    
    let fname = pName . g:fext.savegame
    let fullPath = g:game.pathSavegame . fname
    
    if ( !filereadable( fullPath ) )
        call g:ppp( '[LOAD GAME] ERROR: File not found or file not readable (' . fullPath . '). Try another file or check permissions.' )
        return
    endif
    
    let buf = readfile( fullPath )
    
    if ( len( buf ) != 14 )
        throw( 'ERROR: Savegame file is modified. Aborting.' )
    endif

    let g:player.name           = buf[ 0 ]
    let g:player.motivation     = str2nr( buf[ 1 ] )
    let g:player.productivity   = str2nr( buf[ 2 ] )
    let g:player.experience     = str2nr( buf[ 3 ] )
    let g:player.level          = str2nr( buf[ 4 ] )
    let g:player.fun            = str2nr( buf[ 5 ] )
    let g:player.company        = buf[ 6 ]
    let g:player.score          = str2nr( buf[ 7 ] )
    let g:player.mgrHappy       = str2float( buf[ 8 ] )
    let g:player.title          = buf[ 9 ]
    let g:player.status         = g:status.gameSaved
    let g:backupAge             = str2nr( buf[ 10 ] )
    let g:funGauge              = str2nr( buf[ 11 ] )
    let g:workGauge             = str2nr( buf[ 12 ] )
    let g:msgHappyMaxShown      = str2nr( buf[ 13 ] )

    call g:ppp( '' )
    call g:ppp( '[LOAD GAME] Game loaded.' )
endfunction


" Highscores
function! ShowHighscores()
    let wild    = '*' . g:fext.savegame
    let flist   = split( glob( wild ) , '\n' )
    let scores  = []
    let names   = []
    let titles  = []
    let levels  = []
    
    call g:ppp( '' )
    call g:ppp( 'TOP 15 DEVELOPERS' )
    call g:hr()
    
    " Loading
    for fname in flist
        if ( !filereadable( fname ) )
            call g:ppp( 'ERROR: File not readable (' . fname . '). Please check permissions.' )
            return
        endif
        
        let buf = readfile( fname )
    
        if ( len( buf ) != 14 )
            throw( 'ERROR: Savegame file (' . fname . ') is modified. Aborting.' )
        endif
        
        let names   = add( names, buf[ 0 ] )
        let scores  = add( scores, str2nr( buf[ 7 ] ) )
        " let titles  = add( titles, buf[ 9 ] . ' at ' . buf[ 6 ] )
        let titles  = add( titles, buf[ 9 ] )
        let levels  = add( levels, str2nr( buf[ 4 ] ) )
    endfor
    
    " Adding current player
    if ( g:player.status != g:status.gameNone )
        let names   = add( names, g:player.name )
        let levels  = add( levels, g:player.level )
        " g:player.company
        let scores  = add( scores, g:player.score )
        let titles  = add( titles, g:player.title )
    endif
    
    if ( !len( scores ) )
        call g:ppp( '*** No developers found ***' )
        call g:ppp( '' )
        call g:ppp( 'Either you just installed the game or you never did a savegame or you should hire another recruitment company.' )
        call g:ppp( '' )
        return
    endif

    " Bubles!
    let swapped = 1
    let j = 0
    if ( len( scores ) > 1 )
        while ( swapped )
            let swapped = 0
            let j += 1
            for i in range( len( scores ) - j )
                if ( scores[ i ] > scores[ i + 1 ] )
                    let swapped = 1
                    
                    let tmp = scores[ i ]
                    let scores[ i ] = scores[ i + 1 ]
                    let scores[ i + 1 ] = tmp
                    
                    let tmp = names[ i ]
                    let names[ i ] = names[ i + 1 ]
                    let names[ i + 1 ] = tmp
                    
                    let tmp = titles[ i ]
                    let titles[ i ] = titles[ i + 1 ]
                    let titles[ i + 1 ] = tmp
                    
                    let tmp = levels[ i ]
                    let levels[ i ] = levels[ i + 1 ]
                    let levels[ i + 1 ] = tmp
                endif
            endfor
        endwhile
    endif
    
    let j = len( scores ) - 15
    if ( j < 0 )
        let j = 0
    endif
    for i in range( len( scores ) - 1, j, -1 )
        let s = names[ i ]
        while ( strlen( s ) < 25 )
            let s .= ' '
        endwhile
        let s .= titles[ i ]
        while ( strlen( s ) < 60 )
            let s .= ' '
        endwhile
        let s .= printf( '%3d', levels[ i ] )
        while ( strlen( s ) < 65 )
            let s .= ' '
        endwhile
        let s .= printf( '%6d', scores[ i ] )
        call g:ppp( s )
    endfor
    
    call g:ppp( '' )
endfunction


" Prints the company's welcome message
function! PrintWelcomeMessage()
    call g:ppp( 'Incoming email from the Human Resources department:' )
    call g:ppp( '' )
    call g:ppp( '~~~~' )
    call g:ppp( 'WELCOME to ' . g:player.company . ', ' . g:player.name . '!' )
    call g:ppp( '' )
    call g:ppp( 'We are glad to have you as our new team member.' )
    call g:ppp( 'As this is your first day, please make yourself familiar with the employee handbook, located on your desk. Inside you will find information about the company, our corporate culture and history. An HR representative would contact you shortly, to inform you about your available health benefits and other items of our employee social package.' )
    call g:ppp( 'LOYALTY and DEVOTION are our corporate core values and we are determined to have all of our team members striving to pursue them.' )
    call g:ppp( '' )
    call g:ppp( 'Please also make sure to sign the Letter of Confidentiality, located on your desk and submit it to your line manager within an hour.' )
    call g:ppp( '' )
    call g:ppp( 'Enjoy your time at ' . g:player.company . ' and welcome aboard!' )
    call g:ppp( '' )
    call g:ppp( 'Kindly: ' . g:player.company . ' Human Resources Department' )
    call g:ppp( '~~~~' )
    call g:ppp( '' )
    call g:ppp( 'You take a look around. Your desk contains just a phone, computer and the things the HR lady mentioned about. You finish all the boring paperwork and you are ready to work. Your line manager assigns you a new project, all your accounts are set and ready. You login to Bugzilla and discover you have been assigned a bunch of tasks to do.' )
    call g:ppp( 'Well... off we go!' )
    call g:ppp( '' )
    call g:ppp( '[New game have just started. All menu keys are now enabled.]' )
endfunction


" Company name generation
function! CompanyNameGenerator()
    let idx = Choose( len( g:msgCompanyName1 )  )
    let name1 = g:msgCompanyName1[ idx ]
    let idx = Choose( len( g:msgCompanyName2 ) )
    let name2 = g:msgCompanyName2[ idx ]
    let idx = Choose( len( g:msgCompanyTitle ) )
    let title = g:msgCompanyTitle[ idx ]
    let name = name1 . ' ' . name2 . ' ' . title
    return name
endfunction


" Code lost event generator
function! CodeLostEvent()
    let num = Choose( 20 )
    if ( num % 20 == 0 )
        return 1
    endif

    return 0
endfunction


" Create Backup
function! CreateBackup()
    call BackupAge( 0 )
    call g:ppp( '[BACKUP] ' . GetBackupCreatedMessage() )
endfunction


" Restore Backup
function! RestoreBackup()
    call g:ppp( '' )
    if ( g:backupAge <= g:backupTooOld )
        " Restoring backup
        call g:ppp( '[RESULT: Backup restored] ' . GetBackupRestoredMessage() )
    else
        " No recent backup
        call g:ppp( '[RESULT: Code lost] ' . GetBackupNoMessage() )
        if ( g:player.motivation > 0 )
            let g:player.motivation -= 1
        endif
    endif
    call BackupAge( -2 )
endfunction


" Work
function! DoWork()
    call g:ppp( '[WORK] ' . GetWorkMessage() )
    call ChangeStat( g:stats.experience, 0 )
    call PumpWorkGauge()
    call ReleaseFunGauge()
    call BackupAge( 1 )
    call CodeLostDestiny()
endfunction


" Have Fun
function! HaveFun()
    call g:ppp( '[FUN] ' . GetFunMessage() )
    call ChangeStat( g:stats.fun, 0 )
    call PumpFunGauge()
    call ReleaseWorkGauge()
    call BackupAge( 1 )
    call CodeLostDestiny()
endfunction


" Random message generator
function! GetRandomMessage( array )
    let idx = Choose( len( a:array ) )
    return a:array[ idx ]
endfunction


" Random message interval generator
function! OkToPrint()
    let rnd = Choose( g:randomMessageFactorRange )
    if ( rnd == g:randomMessageFactor )
        return 1
    endif
    return 0
endfunction


" Code Lost event check/action
function! CodeLostDestiny()
    if ( CodeLostEvent() )
        call g:ppp( '' )
        call g:ppp( '[CODE LOST] ' . GetCodeLostReason() )
        call g:ppp( '' )
        call RestoreBackup()
    endif
endfunction


" Get Lazy message
function! GetLazyMessage()
    return GetRandomMessage( g:msgLazyPerson )
endfunction


" Get Workaholic message
function! GetWorkaholicMessage()
    return GetRandomMessage( g:msgWorkaholicPerson )
endfunction


" Get Code Lost reason
function! GetCodeLostReason()
    return GetRandomMessage( g:msgCodeLostReasons )
endfunction


" Get Backup Created message
function! GetBackupCreatedMessage()
    return GetRandomMessage( g:msgBackupCreated )
endfunction


" Get Backup Restored message
function! GetBackupRestoredMessage()
    return GetRandomMessage( g:msgBackupRestored )
endfunction


" Get No Backup message
function! GetBackupNoMessage()
    return GetRandomMessage( g:msgBackupNo )
endfunction


" Get Manager Happy message
function! GetManagerHappyMessage()
    return g:msgManagerHappy[ float2nr( g:player.mgrHappy ) ]
endfunction


" Get work message
function! GetWorkMessage()
    if ( OkToPrint() )
        return GetRandomMessage( g:msgDoingWork )
    endif
    return ''
endfunction


" Get fun message
function! GetFunMessage()
    if ( OkToPrint() )
        return GetRandomMessage( g:msgHavingFun )
    endif
    return ''
endfunction


" Input command validator
function! CommandValid( commandChar )
    let valid = 0

    if ( strlen( a:commandChar ) > 1 )
        throw( "CommandValid( '" . a:commandChar . "' ): ERROR: Argument length is more than 1. Not a single char." )
    endif

    for okCommand in keys( g:validCommands )
        if ( a:commandChar ==# okCommand )
            let valid = 1
        endif
    endfor

    return valid
endfunction


" Sets/resets the backup age
function! BackupAge( factor )
    if ( a:factor )
        let g:backupAge += 1 | " Increase
    elseif ( a:factor == 0 )
        let g:backupAge = 0 | " Reset
    else
        let g:backupAge -= a:factor | " Decrease
    endif
endfunction


" Backup age check
function! BackupTooOld()
    if ( g:backupAge > g:backupTooOld )
        return 1
    endif
    return 0
endfunction


" Level Up check and action
function! LevelUp()
    if ( g:player.level > len( g:msgProgressDescription ) -1 )
        return
    endif
    if ( g:player.experience >= keys( g:msgProgressDescription[ g:player.level ] )[ -1 ] )
        let g:player.level += 1
        let g:player.experience = 0
        let g:player.title = g:msgProgressDescription[ g:player.level ][ 0 ]
    else
        for [ pts, msg ] in items( g:msgProgressDescription[ g:player.level ] )
            if ( g:player.experience >= pts )
                let g:player.title = msg
            endif
        endfor
    endif
endfunction


" Change stat
" step is not mandatory
function! ChangeStat( stat, step )
    if ( !has_key( g:stats, a:stat ) )
        throw( 'ChangeStat(' . a:stat . ', ' . a:step . '): ERROR: stat does not exist.' )
    endif
    
    let min = 0
    let thisStep = a:step
    
    if ( a:step == min )
        let thisStep = g:statRange[ a:stat ][ 'step' ]
    endif
    
    let g:player[ a:stat ] += thisStep
    
    if ( g:player[ a:stat ] < min )
        let g:player[ a:stat ] = min
    endif
    if (  g:statRange[ a:stat ][ 'max' ] && g:player[ a:stat ] > g:statRange[ a:stat ][ 'max' ] )
        let g:player[ a:stat ] = g:statRange[ a:stat ][ 'max' ]
    endif
    
    if ( has_key( g:statRelations, a:stat ) )
        let nextStep = 0
        
        if ( a:stat ==# g:stats.experience )
            call LevelUp()
        elseif ( ( a:stat ==# g:stats.experience ) || ( a:stat ==# g:stats.motivation ) )
            let nextStep = g:stats.motivation + ( g:stats.experience * ( g:stats.level + 1 ) )
        else
            let nextStep = g:statRange[ g:statRelations[ a:stat ] ][ 'step' ]
        endif

        call ChangeStat( g:statRelations[ a:stat ], nextStep )
    endif
endfunction


function! PrintMgrHappyMessage()
    if ( ( float2nr( g:player.mgrHappy * 100 ) % 100 == 0 ) && !g:msgHappyMaxShown )
        call g:ppp( '' )
        call g:ppp( '[MANAGER] ' . GetManagerHappyMessage() )
        
        " Bugfix with the max value
        if ( g:player.mgrHappy == 10.00 )
            let g:msgHappyMaxShown = 1
        else
            g:msgHappyMaxShown = 0
        endif
    endif
endfunction


" Confirm Quit
function! ConfirmQuit()
    call g:ppp( '' )
    call g:ppp( '[QUIT GAME] Are you sure? Press "y" or "Y" to QUIT, any other key to go back to game...' )
    let userChoice = toupper( nr2char( getchar() ) )
    
    if ( userChoice ==? 'Y' )
        return 1
    endif
    
    return 0
endfunction




" ====================================================================
" TOOLS


" Horizontal ruler
function! g:hr()
    call g:ppp( '--------------------' )
endfunction


" Menu input
function! g:getMenuChoice( defaultChoice )
    let userChoice = ''

    let validCommand = 0
    while ( !validCommand )
        let userChoice = nr2char( getchar() )
        let validCommand = CommandValid( userChoice )

        if ( empty( userChoice ) )
            userChoice = a:defaultChoice
        endif

        if ( !validCommand )
            call g:ppp( 'ERROR: Invalid key ('.userChoice.'). Valid keys: ' . join( keys( g:validCommands ) ) )
        endif
    endwhile

    return userChoice
endfunction


" Function to get a string of characters in the class [A-z0-9_]
" Control keys accepted: Enter and Backspace
function! g:getString( promptS, allowEmpty, valueDefault, maxLength )
    let value   = a:valueDefault
    let lineS   = a:promptS
    let cursorX = '_'
    let maxLen = 256
    
    if ( a:maxLength =~ '\v^[0-9]+$' )
        let maxLen = a:maxLength
    endif
    
    call append( line( "$" ), lineS . value . cursorX )
    call g:scroll()

    let keyPress = ''
    while ( 1 )
        let keyPress = getchar()
        
        if ( keyPress == '13' )
            if ( !empty( value ) )
                return value
            elseif ( a:allowEmpty )
                return value
            endif
        elseif ( keyPress == "\<BS>" && strlen( value ) > 0 )
            let value = value[:-2]
        else
            let keyPress = nr2char( keyPress )
            
            if ( keyPress =~ '\v^[A-z0-9_]+$' && strlen( value ) < maxLen )
                let value .= keyPress
            endif
        endif
        
        call setline( line( "$" ), lineS . value . cursorX )
        redraw
    endwhile
endfunction


" Screen printing function
function! g:ppp( string )
    call append( line( "$" ), a:string )
    call cursor( "$", 1 )
    call g:scroll()
endfunction


" Print array
function! g:printArray( array )
    for x in a:array
        call g:ppp( x )
    endfor
endfunction


" Print hash
function! g:printHash( hashH, offsetDefault )
    let offset = a:offsetDefault
    if ( empty( offset ) )
        let offset = 20
    endif
    for key in keys( a:hashH )
        let val = a:hashH[ key ]
        let s = key
        while strlen( s ) < offset
            let s .= ' '
        endwhile
        let s .= val
        call g:ppp( s )
    endfor
endfunction


" Force scroll
function! g:scroll()
    execute "normal G"
    redraw
endfunction


" Clear screen
function! g:cls()
    for i in range( 100 )
        call g:ppp( '' )
    endfor
endfunction




" ====================================================================
" GLOBAL VARIABLES


" Game time
let g:backupTooOld          = 10
let g:backupAge             = 0


" Player names
let g:namesMaxLen           = 20


" Gauges
let g:funMax                = 10
let g:funGauge              = 0
let g:workMax               = 10
let g:workGauge             = 0


" Allow or not empty values
let g:emptyValue = {
    \'allow'                : 1,
    \'reject'               : 0
\}


" Statuses
let g:status = {
    \'gameNone'             : -2,
    \'gameOver'             : -1,
    \'gameNotSaved'         : 0,
    \'gameSaved'            : 1
\}


" Game status messages
let g:msgGameStatus = {
    \g:status.gameNone      : '[NoGame]',
    \g:status.gameOver      : '[Over!]',
    \g:status.gameNotSaved  : '[Unsaved]',
    \g:status.gameSaved     : '[Saved]',
\}


" Stats
let g:stats = {
    \'fun'                  : 'fun',
    \'motivation'           : 'motivation',
    \'productivity'         : 'productivity',
    \'experience'           : 'experience',
    \'mgrHappy'             : 'mgrHappy',
    \'name'                 : 'name',
    \'level'                : 'level',
    \'company'              : 'company',
    \'score'                : 'score',
    \'title'                : 'title',
    \'status'               : 'status'
\}


" Relations
let g:statRelations = {
    \g:stats.fun            : g:stats.motivation,
    \g:stats.motivation     : g:stats.productivity,
    \g:stats.experience     : g:stats.productivity,
    \g:stats.productivity   : g:stats.mgrHappy
\}


" Stat range
let g:statRange = {
    \g:stats.fun            : { 'step' : 1, 'max' : 10 },
    \g:stats.motivation     : { 'step' : 2, 'max' : 100 },
    \g:stats.productivity   : { 'step' : 2, 'max' : 100 },
    \g:stats.experience     : { 'step' : 2, 'max' : 0 },
    \g:stats.mgrHappy       : { 'step' : 0.05, 'max' : 10 },
    \g:stats.name           : { 'step' : 0, 'max' : 0 },
    \g:stats.level          : { 'step' : 0, 'max' : 0 },
    \g:stats.company        : { 'step' : 0, 'max' : 0 },
    \g:stats.score          : { 'step' : 0, 'max' : 0 },
    \g:stats.title          : { 'step' : 0, 'max' : 0 },
    \g:stats.status         : { 'step' : 0, 'max' : 0 }
\}


" Randomness of messages
let g:randomMessageFactorRange  = 10
let g:randomMessageFactor       = 3


" QUIT GAME
let g:commandGlobalQuit = 'Q'


" Bugfix with max mrgHappy value
let g:msgHappyMaxShown = 0


" Valid commands list
let g:validCommands = {
    \'n' : 'NEW GAME           - Starts a new game',
    \'s' : 'SAVE GAME          - Saves the current game',
    \'l' : 'LOAD GAME          - Loads a game',
    \'h' : 'HIGHSCORES         - Shows the highscore table',
    \'c' : 'CLEAR SCREEN       - Clears the screen',
    \'q' : 'QUIT GAME          - Quits the game',
    \'1' : 'WORK               - Produce programing code (in game)',
    \'3' : 'HAVE FUN           - Have some fun (in game)',
    \'2' : 'CREATE BACKUP      - Creates some form of code backup (in game)',
    \'?' : 'HELP               - This help',
    \' ' : '(SPACEBAR)BOSS KEY - Fakes the game to look like a real code',
    \'p' : 'PLAYER STATS       - Shows the player statistics'
\}


" File extensions
let g:fext = {
    \'savegame' : '.dev',
    \'buffer'   : '.buf'
\}




" ====================================================================
" GAME TEXT


" Game intro help
let g:msgIntro = [
    \g:game.nameFull . ' v' . g:game.version . ' (' . g:game.versionDate . ')',
    \'by ' . g:game.authorName . ', ' . g:game.authorContact,
    \'Download location: ' . g:game.whereToGet,
    \'License: ' . g:game.license,
    \'',
    \'Boss key code Text::CSV (C)1997 Alan Citterman. (C)2007-2009 Makamaka Hannyaharamitu.',
    \'Thanks to Damian Conway for the great tutorials and of course last but not least to Bram Moolenaar.',
    \'',
    \'INTRO',
    \'--------------------',
    \'To play the game, press one of the game keys. (Check the Help first)',
    \'All messages are simply appended to the current buffer, so you could use it as a game log or screenshot.',
    \'Only WORK, HAVE FUN and CREATE BACKUP actions are considered "game" actions. All the rest does not affect the game mechanics at all.',
    \'',
    \'NOTE: This game was created to kill time between tasks and is designed to be played as such, so no game colors, pics, animations or whatever art. I chose specifically to run it in the editor''s buffer, so from a distance it will look just like a document you edit.',
    \'',
    \'RULES',
    \'--------------------',
    \'- Work to produce software and gain experience/level up',
    \'- Backup regularly to prevent code loss',
    \'- Have fun to be more productive',
    \'- Avoid making the manager angry',
    \'- Game is over if you are fired; otherwise you can play as long as you like',
    \'',
    \'MOST IMPORTANT KEYS',
    \'--------------------',
    \'n) NEW GAME           - Begins a new game',
    \'q) QUIT GAME          - Quits the game',
    \'?) HELP               - Short help',
    \'SPACEBAR) BOSS KEY    - Press this if the manager is around and strike a key when he''s gone',
    \'===============================================================',
    \'',
    \'GET READY PLAYER1! Press a game key (check the Help "?" first)...',
    \'',
\]


" Game core data
" LevelUp trigger = 'UP'
let g:msgProgressDescription = [
    \{ 
    \'0'    : 'Staplemaster',
    \'25'   : 'Lord of the Stickies',
    \'50'   : 'Windows Notepad guru',
    \'100'  : 'Minesweeper olympic champion',
    \'150'  : 'UP'
    \},
    \{
    \'0'    : 'Microsoft Word ambassador',
    \'100'  : 'PowerPoint power pointer',
    \'150'  : 'BAT-files hacker (Windows power user)',
    \'200'  : 'UP'
    \},
    \{
    \'0'    : 'Linux newbie',
    \'100'  : 'Shell scripter',
    \'200'  : 'Linux basic administrator',
    \'300'  : 'UP'
    \},
    \{
    \'0'    : 'Static HTML developer',
    \'100'  : 'Javascript guru',
    \'200'  : 'PHP hero',
    \'300'  : 'MySQL miner',
    \'400'  : 'Perl monk',
    \'500'  : 'Python hunter',
    \'600'  : 'Ruby rush rider',
    \'700'  : 'UP'
    \},
    \{
    \'0'    : 'Oracle expert',
    \'100'  : 'Java drinker',
    \'300'  : 'C wizard',
    \'500'  : 'Assembly necromancer',
    \'700'  : 'Linux core developer',
    \'1300' : 'Better than Linus Torvalds',
    \'1700' : 'UP'
    \},
    \{
    \'0'    : 'Robocop developer',
    \'300'  : 'Terminator developer',
    \'500'  : 'NASA researcher',
    \'900'  : 'HAL-9000 developer',
    \'1300' : 'UP'
    \},
    \{
    \'0'    : 'DeVinci code breaker',
    \'400'  : 'Starship Titanic engineer',
    \'900'  : '"42" question researcher'
    \}
\] 


" Company names
let g:msgCompanyName1 = [
    \'Elite', 'Super', 'Micro', 'Alien', 'Cartoon', 'Linux',
    \'Star', 'Open Source', 'Barbarian', 'Genetically Modified',
    \'Bytecode', 'Compiled', 'Debugged', 'Mutant', 'Perl', 'Python',
    \'Electric', 'Bugged', 'Insane', 'Geeky', 'HTTP', 'Pink', 'Yellow',
    \'Retarded', 'Smashed', 'Genetic', 'Swamp', 'Popfolk', 'Pwned',
    \'Dundas Square'
\]


let g:msgCompanyName2 = [
    \'Ladybugs', 'Munchers', 'Munchkins', 'Witches', 'Trollfaces',
    \'Fleas', 'Roaches', 'Goblins', 'Coders', 'Code Ladies',
    \'Hackers', 'Gamers', 'Wizards', 'Terminators',
    \'Invaders', 'Ninjas', 'Bugs', 'Worms', 'Centipedes',
    \'Pacmans', 'Banditos', 'Jelly', 'Romerojohns',
    \'Monkeys', 'Donkeys', 'Kikimoras', 'Divas', 'Bieberjustins',
    \'Honeybooboos', 'Bangers', 'Grumpycats', 'Lolcatz',
    \'Ihazcheerburgerz'
\]


let g:msgCompanyTitle = [ 'Ltd.', 'Inc.', 'Corporation' ]


let g:msgLazyPerson = [
    \'You spent 2 hours on a lunch break. You don''t feel like you want to get back in the office. The sun shines happily.',
    \'In the early afternoon, you decide to go out for a walk in the nearby park. You grab a pack of peanuts from your drawer. Feeding squirrels is fuch a fun.',
    \'After the lunch break you decide to go for cofee, you order a single-shot espresso and sit near the window, silently enjoying the warm sunrays coming in. Ahhh.',
    \'In the early afternoon, you decide to go for cofee. Some girl keeps smiling at you. After 20 minutes making sure she''s alone, you take a chance for a chat. You forgot how much time went there.',
    \'You don''t feel like working today. You spend the afternoon discussing movies with the guys from the QA department.',
    \'You don''t feel like working today. You spend the afternoon discussing the latest DistroWatch articles with the System Administrator.',
    \'You don''t feel like working today. You spend the afternoon discussing Apple II games with the other guys.',
    \'The sun shines and you feel so sleepy. You are no longer a cat, you are a bagel.',
    \'Nintendo just released a new Super Mario Kart game. You spend the afternoon reading reviews about it.',
    \'You feel so sleepy this afternoon. You go for a walk in the park, but you found a bench. You quickly fall asleep. You start dreaming some strange dream about a hand, a drop of water and blue-eyed people. A voice keeps repeating "The sleeper must awaken!"',
    \'You spend the afternoon browsing travel websites, trying to choose where to go for a trip.',
    \'You don''t have any high and mediun priority tasks today and you spend the whole afternoon watching Youtube videos.',
    \'You can''t concentrate on anything today, so you decide and spend the afternoon chatting on some fan chat, why the Bulbasaur is better than a Charmander and how cool is the SolarBeam attack move.',
    \'You spend half an hour thinking on the everlasting wisdom: Who is General Failure and why is he reading my disk?'
\]


let g:msgWorkaholicPerson = [
    \'You work too much. Work is not such a fun anymore.',
    \'You work way too much. It''s good to get a break.',
    \'You are working harder than anyone now. Your manager praises you and gives you even more work. Your team mates work quietly.',
    \'You are now workaholic. It''s cool. I guess.',
    \'You missed a dinner with your girlfriend. Your work is more important than anything else.',
    \'You missed to see your girlfriend today. You decide to work more. Your girlfriend is angry.',
    \'You work and work and work and work and work and wok and wokr and owkr and kowr adn rowk nda kwor...',
    \'You disrespect anything besides your work. You receive an SMS. Your girlfriend just moved out. So what - you work.',
    \'What''s more important than programing? Nothing.',
    \'It is said that all programing gurus have either white beards or white mustaches and probably white and/or bold hair. You wonder that the KFC guy probably also invented a programing language...',
    \'Codito ergo sum...'
\]


let g:msgCodeLostReasons = [
    \'Your computer just crashed.',
    \'Your computer had a power failure.',
    \'The office just had a power failure.',
    \'A lightning struck nearby. The neighbourhood blackened out.',
    \'Your hard drive just died.',
    \'A newbie sysadmin just restarted your computer by accident.',
    \'You kicked your powercable by accident. Your computer died.',
    \'The cat of the office secretary just ate your power cable.',
    \'Your computer got infested by roaches.',
    \'Two newlywed spiders went on a honeymoon in your power adapter. It died',
    \'The three-year-old kid of the secretary just pulled off your power cable. Now it looks cute at you and awaits your approval.',
    \'That cute QA girl just blackbox-tested the effect of spilling cofee on your computer by accident. She smiles innocent at you.',
    \'In the rush of quick-reading a bunch of stupid emails you clicked and installed a malware. Your computer got hacked.',
    \'Your computer got infected by a legendary misterious ancient Commodore64 virus. You watch the letters dissapear off the screen and wonder how this is possible.',
    \'Malicious unknown team-mate remapped your keyboard. CTRL-S killed all processes and logged you off. You wonder who that might be. Smeagol-like laugh can be heard from a nearby cubbicle.',
    \'Your computer overheated and was shutdown by BIOS.',
    \'An evil Bieberjustin visited your office. All computers instantly died. All female team-mates scream of joy, all managers scream of insanity. One sysadmin tries a demonic spell, hidden in the basement and sitting in a pentagram of candles and blood of unknown origin, in a desperate try to revive the system. His t-shirt reads "Cannibal Corpse".',
    \'The office was struck by a strange alien ship. On its side you read "Titanic". A killer blonde bombshell in miniskirt happily looks around.',
    \'All computers in the office went shutdown. You look around and see two droids. One is small in white and blue, just went out the server room. The other looks like gold and complains all the time.',
    \'Savanna Samson visited the office. The sysadmins jumped of joy and kicked the server power cable by accident. All female team-mates pull their hairs and tried to kill her with a look, but Savanna is DEF+99 on LVL99. Savanna CHARM rose.',
    \'After a zombie-walk parrade on Halloween a bunch of zombies stormed the office and ate the sysadmin. The project manager bangs its head on the wall.',
    \'The company new policy was migration to WindowsServer. The sysadmin secretly sabotages the project by restarding random computers.',
    \'You enter the office and you see a mess. All computers are broken. The security camera shows a moose who broke in by curiosity, took a parade walk and went away. Your project manager curses without limits, but summons an evil Bieberjustin by accident. The Bieberjustin ate him and disapeared within a thin cloud of smoke. The QA department silently mourns for a minute.',
    \'Sudenly an evil Bieberjustin appears in the middle of the office and casts a spell. All employees sudenly faint. Upon waking up you realize all power cables have been eaten. Few pieces of isolation lie abbandoned around.',
    \'On his first day a new employee went crazy and stole all power cables. You realize his t-shirt reads ".NET". Suddenly a voice is heard within the void "Beware of the Dark Side. If once you start down the Dark Path, forever will it dominate your destiny. Mmmhmm".',
    \'Someone costumed as Darth Vader broke in the office and went on a killing spree. The sysadmin bravely suceeded to unmask him to discover it was an evil Bieberjustin, but he ate him and disapeared in a thin cloud of smoke.',
    \'You hear "miam" sounds and your computer just died. You look below the desk. The grumpy cat grumpily looks at you.',
    \'Maru-maru attacked your computer. You lost the code. He is happy.',
    \'Honey Boo Boo just went in the office and spilled an energy drink all over by accident. All computers appear affected and died. However she is a nice person and the sysadmin does not kill her. She smiled and left. The project manager tried to commit suicide with a plastic spoon, but killed a cockroach by accident. The QA department silently mourns for a minute.',
    \'You look around and notice the sysadmin goes sweaty. A portal to another dimension suddenly opens. You see John Romero head on a pole. A bunch of monsters break in and start killing everybody around. You scream IDDQD just before a fireball blasts your cubicle. However your computer dies. Somebody screams IDKFA and a bunch of BFGs sudenly appear. Everybody grabs one and blasts the portal. Kills: 100%. Level complete. However your computer was blasted and you realise the project manager was kidnapped into Hell. The QA department silently mourns for a minute.',
    \'Bright colorfull light comes trough the window. You realize a rainbow has been delivered outside the office. The space unicorn quietly sits in the kitchen and drinks cofee. Sudenly an evil Bieberjustin breaks in and attacks him, but got zapped by his so true of aim marshmallow laser. The zapped Bieberjustin flies few meters back and lands on top of your computer. Your computer dies.',
    \'You quietly sit while a music appears as from nowhere and gets louder and louder. A pervertly childish melody drives all employees to crazyness. In a desperation to stop it everybody breaks their computer. The Nyan cat happily jumps into hyperspace',
    \'You hear the project manager discussing that "Delta Force" is the dumbest movie ever made. Bright beautiful light appears out of nowhere and Chuck Norris comes out of it. He kicks the project manager with a round house kick and disappears in a thin cloud of smoke. The project manager flies few meters back and lands dead on your computer, which get smashed to pieces. The QA department silently mourns for a minute.',
    \'An evil Bieberjustin broke into the office and ate your project manager. Sudenly McGyver came out of nowhere, grabbed all power cables and hanged him in the middle of the office. The QA department silently mourns for a minute.'
\]


let g:msgBackupCreated = [
    \'Backup created.',
    \'Code sucessfully checked into the repository.',
    \'GITHUB quietly munches your code changes. You relax on the chair.',
    \'All code changes went safely to the GITHUB in a fraction of second. You are glad the company does not use TFS.',
    \'Your code went to the code vault. Everything is under control.'
\]


let g:msgBackupRestored = [
    \'Backup restored.',
    \'Code successfully checked out. You relax.',
    \'GITHUB saves the day. Code checked out.',
    \'Backup restored. Phew.'
\]


let g:msgBackupNo = [
    \'Backup not found. You lost your code.',
    \'No recent backup found. Your code is lost. You are angry.',
    \'A programer who lost his code is evil. Next time do some backups.',
    \'You are in violation of the company policy - you don''t have a recent repository check in, so you lost your code.'
\]


let g:msgManagerHappy = [
    \'You were warned. No more room for mistakes. You are now fired.',
    \'Your manager is more than angry at you. You are about to get fired. Watch out.',
    \'Your performance is untolerable. Your manager is angry. Few more mistakes and you are out.',
    \'Your performance is unsatisfactory. Your manager wants you to perform to the standards of the company. He schedules another performance review for the next week.',
    \'Your performance is unsatisfactory. You are asked to keep up with the company standards.',
    \'Your manager is satisfied with your performance. You are performing according to the company standards.',
    \'Seems you are doing well. Your manager is satisfied.',
    \'Your manager feels satisfied with your performance level.',
    \'You are doing great! Your manager smiles at you.',
    \'Your performance is fabulous! Your manager is happy. One girl from the QA department secretly admires you.',
    \'You are the godfather of the company. Your manager praises you. The QA department stands up and sings "Alleluia" every morning when you enter the office. The secretary lady serves you cofee and brings you a copy of The Linux Journal, which she personally bought for you. You feel like Don Johnson. Yeah, whatever.'
\]


let g:msgDoingWork = [
    \'echo( "hello world!" );',
    \'call add( n, x );',
    \'return( 0 );',
    \'for ( i = 0; i < 93; i++ )',
    \'" This comment is for making sure this program have one.',
    \'echo( "' . g:game.nameShort . ' v' . g:game.version . ' by Evgueni Antonov a.k.a. Stray Feral 2013." )',
    \'call ShowHelp()',
    \'let a = b',
    \'call append( line( "$" ), "lol :P" )',
    \'You produce a delightful line of code. You lean back and enjoy it for five minutes.',
    \'let msgStatus .= "another line of code"',
    \'let g:flags = { pos: 1, neg: 0 }'
\]


let g:msgHavingFun = [
    \'Playing Tetris is always so cool. After some time playing you close your eyes and still see falling blocks.',
    \'Playing Karateka on an Apple ][ emulator - the ultimate pleasure!',
    \'Playing Bolo on an Apple ][ emulator - ahhhh cool!',
    \'Playing Sabotage on an Apple ][ emulator - Rrrroarrrrr!!!',
    \'Super Mario on an Apple][ emulator looks so much cooler.',
    \'Green Beret on MAME - one of the ultimate games!',
    \'Altered Beast!! Is there a better game?!',
    \'One hour playing Outrun. "Passing Breeze" is the best song!',
    \'F-Zero for SNES! Still of the coolest race games ever!',
    \'Super Mario Kart for SNES! Is there funnier game here?',
    \'You spend one hour geocaching in the nearby forest. Cache not found, but still fun.',
    \'After one hour of geocaching you find the cache. You take small red pencil and you leave small plastic toy soldier. TFTC!',
    \'You put your headphones and enjoy a 80s-90s compilation. Today''s music is so much worse...',
    \'You decide to boost some music of your childhood in the headphones. The songs from Sepultura''s "Beneath the remains" pierce your ears. Orgasmic.',
    \'You spend time bicycling around. The fresh air and the sun feel great.',
    \'You spend time of joyful jogging. Nothing more refreshing.',
    \'You watch "The Neverending Story". You still feel so sad when Artax dies in the swamp.',
    \'You watch "The Neverending Story". Morla''s sneezind is the funniest thing ever.',
    \'You watch "Die Vorstadtkrokodile". "Amada mia, amore mio" is the coolest song ever.',
    \'You watch all episodes of "Verano Azul". You watch all episodes again. You watch all episodes all over again. You can''t stop watching. The coolest TV series ever. You sing-along the theme.',
    \'You visit a coin-op play hall and spend all your coins playing Frogger.',
    \'You watch "The Neverending Story". You sing-along with Limahl on the theme song. Still of the best synth-pop hits ever.',
    \'You watch "Labyrinth". "Magic dance" is still of the best songs ever.',
    \'You watch the old "Star Wars" trilogy. You spend one hour practicing your jedi skills. A bug crashes on the nearby window. You seem happy to kill a Tie-fighter.',
    \'You watch "American werewolf in London". Still no other movie ever show the transformation human-to-werewolf in full detail and close-up. Ah. You notice it''s midnight. Outside the full moon just rose, the sky is dark and full of stars. You feel something feral emerging inside you. You open the window and you howl at the moon. Refreshing.',
    \'You spend half an hour posing on the mirror. You feel He-Man living within you. Your manager runs away scared. A girl from the QA department secretly admired you.',
    \'You spend time watching "War Games". This movie is still so much cool!',
    \'You spend time watching "Labyrinth". You still secretly wish to marry Jennifer Connelly.',
    \'You spend time watching all "Benji, Zax and the alien prince" episodes. Still admire how the prince beat the record on "Centipede". You start considering getting a dog.',
    \'You watch a very old recording of Rodney Mullen doing tricks. You can''t skate, but it still feels cool.',
    \'You spend time talking to the nice girl from the QA department. Bugfixing feels like a piece of cake now.',
    \'You watch an episode of "Blake''s 7". You remember you liked to play Avon''s character as a kid. No wonder you are now a programer.',
    \'Sven Wittekind is in the city. You can''t miss him and spend the night on a wild hard-techno party. You feel your soul purified.',
    \'You spend time learning Vimscript. Feels nice.',
    \'You install DosBox and spend time playing Maniac Mansion. You enjoy the art of the Green Tentacle.',
    \'You spend time playing "Stone Age" on a DosBox. Still one of the two games with the best FM music ever! The other of course is "Dune".',
    \'You spend one hour playing Quake III, mercilessly fragging all the team-mates. Revenge is yours.',
    \'You spend your day off playing versions of "Goody" for different platforms. Still one of the best DOS-era games ever!',
    \'You spend an hour playing Xenon II. Orgasmic.',
    \'You spend an hour playing Space Quest I. Historic!',
    \'You can''t stop playing Dune II. Who can?',
    \'You can''t stop playing Ur-Quan Masters. You are the master of the universe. And "Potato juice" is the catchiest song in the music history EVER!! Carly Rae Japsten eat your socks!',
    \'You spend time enjoying Second Reality on a DosBox. Unduplicable!',
    \'You spend wonderful time playing Pinball Fantasies. You break your left SHIFT key, but who cares.',
    \'You spend the whole afternoon piercing your ears with the sounds of various old .MODs, .STMs, .S3Ms and few .XMs. Nobody in the office can understand why you enjoy crappy tunes so much. They understand nothing of music. You can''t forget the cool time spent years ago listening to tunes on 12mHz PC Speaker frequency, before getting your first SoundBlaster 2.0. Ah...',
    \'You spend time watching all Cynthia Rothrock movies. Cutie.',
    \'After watching "Kickboxer 1" all over again you go out practicing your skills, but unlike the movie, the palm tree always wins against you.',
    \'Watching "Blood Sport". Rrrrroarrr!',
    \'Watching "Best of the best 1". Probably the best role of Eric Roberts ever.',
    \'After watching "Breaking Away" all over again you can''t resist the temptation and grab your bicycle. One hour of cycling feels so refreshing.',
    \'Roses are #FF0000, Violets are #0000FF, All my base belongs to you.',
    \'Black holes are where God divided by zero.'
\]


" Okay, funny or not but I put this just in case
" The folowing is a Perl code, part of Text::CSV 1.21 and is pasted from
" the module source as available on CPAN
" http://cpansearch.perl.org/src/MAKAMAKA/Text-CSV-1.21/lib/Text/CSV.pm
" Copyright (C) 1997 Alan Citterman. All rights reserved. 
" Copyright (C) 2007-2009 Makamaka Hannyaharamitu.
let g:msgBossKey = [
    \'sub AUTOLOAD {',
    \'    my $self = $_[0];',
    \'    my $attr = $Text::CSV::AUTOLOAD;',
    \'    $attr =~ s/.*:://;',
    \'',
    \'    return if $attr =~ /^[A-Z]+$/;',
    \'    Carp::croak( "Can''t locate method $attr" ) unless $attr =~ /^_/;',
    \'',
    \'    my $pkg = $Text::CSV::Worker;',
    \'',
    \'    my $method = "$pkg\::$attr";',
    \'',
    \'    $Text::CSV::DEBUG and Carp::carp("''$attr'' is private method, so try to autoload...");',
    \'',
    \'    local $^W;',
    \'    no strict qw(refs);',
    \'',
    \'    *{"Text::CSV::$attr"} = *{"$pkg\::$attr"};',
    \'',
    \'    goto &$attr;',
    \'}',
    \'',
    \'',
    \'',
    \'sub _load_xs {',
    \'    my $opt = shift;',
    \'',
    \'    $Text::CSV::DEBUG and Carp::carp "Load $Module_XS.";',
    \'',
    \'    eval qq| use $Module_XS $XS_Version |;',
    \'',
    \'    if ($@) {',
    \'        if (defined $opt and $opt & $Install_Dont_Die) {',
    \'            $Text::CSV::DEBUG and Carp::carp "Can''t load $Module_XS...($@)";',
    \'            return 0;',
    \'        }',
    \'        Carp::croak $@;',
    \'    }',
    \'',
    \'    push @Text::CSV::ISA, ''Text::CSV_XS'';',
    \'',
    \'    unless (defined $opt and $opt & $Install_Only) {',
    \'        _set_methods( $Text::CSV::Worker = $Module_XS );',
    \'    }',
    \'',
    \'    return 1;',
    \'};',
    \'',
    \'',
    \'sub _load_pp {',
    \'    my $opt = shift;',
    \'',
    \'    $Text::CSV::DEBUG and Carp::carp "Load $Module_PP.";',
    \'',
    \'    eval qq| require $Module_PP |;',
    \'    if ($@) {',
    \'        Carp::croak $@;',
    \'    }',
    \'',
    \'    push @Text::CSV::ISA, ''Text::CSV_PP'';',
    \'',
    \'    unless (defined $opt and $opt & $Install_Only) {',
    \'        _set_methods( $Text::CSV::Worker = $Module_PP );',
    \'    }',
    \'};',
    \'',
    \'',
    \'',
    \'',
    \'sub _set_methods {',
    \'    my $class = shift;',
    \'',
    \'    #return;',
    \'',
    \'    local $^W;',
    \'    no strict qw(refs);',
    \'',
    \'    for my $method (@PublicMethods) {',
    \'        *{"Text::CSV::$method"} = \&{"$class\::$method"};',
    \'    }',
    \'',
    \'    if ($Text::CSV::Worker eq $Module_XS) {',
    \'        for my $method (@UndocumentedXSMethods) {',
    \'            *{"Text::CSV::$method"} = \&{"$Module_XS\::$method"};',
    \'        }',
    \'    }',
    \'',
    \'    if ($Text::CSV::Worker eq $Module_PP) {',
    \'        for my $method (@UndocumentedPPMethods) {',
    \'            *{"Text::CSV::$method"} = \&{"$Module_PP\::$method"};',
    \'        }',
    \'    }',
    \'',
    \'}'
\]




" ---------------------------------------------------------
" Random functions by Bee-9 (name of author is unknown)
let rnd = localtime() % 0x10000

function! Random()
  let g:rnd = (g:rnd * 31421 + 6927) % 0x10000
  return g:rnd
endfun

function! Choose(n) " 0 n within
  return (Random() * a:n) / 0x10000
endfun 
" ---------------------------------------------------------

" ~~~EOF~~~
