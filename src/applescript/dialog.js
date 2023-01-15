const exec = require('./exec.js')

async function showDialog(
    title,
    text,
    buttons,
    givingUpAfter = 30,
    showIcon = false
) {
    showIcon = false
    const SCRIPT = ` 
--set theImage to ((path to downloads folder ) & "logo.png") as string 
set dialogText to "${text}"                                                                                
set button1Label to "${buttons[0]}"
set button2Label to "${buttons[1]}"
set timeoutValue to ${givingUpAfter} 
set result to (display dialog dialogText with title "${title}" buttons {button1Label, button2Label} default button button1Label giving up after ${givingUpAfter} ${
        showIcon ? 'with icon file theImage' : ''
    })
set buttonReturned to result's button returned
return buttonReturned`
    return await exec(SCRIPT)
}

async function askQuestion(questionText, dialogTitle='Set your intention', defaultText='') {
    const SCRIPT = `
try    
set dialogText to "${questionText}"
set defaultText to "${defaultText}"
set dialogTitle to "${dialogTitle}"
set result to display dialog dialogText default answer defaultText with title dialogTitle
set userInput to result's text returned
return userInput
end try`
    return await exec(SCRIPT)
}
module.exports = { showDialog, askQuestion }
