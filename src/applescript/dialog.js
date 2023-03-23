const exec = require('./exec.js')

function stringify(buttons) {
    return buttons.map((b) => `"${b}"`).join(', ')
}
async function showDialog(title, text, buttons, givingUpAfter = 30) {
    const [defaultButton] = [...buttons].reverse() // grab the right most button

    const SCRIPT = ` 
    try
        set result to ( ¬ 
            display dialog \"${text}\" ¬ 
            with title \"${title}\" ¬
            buttons { ${stringify(buttons)} } ¬
            default button \"${defaultButton}\" ¬ 
            giving up after ${givingUpAfter} ¬
            with icon alias ( ¬
                ( path to application support from user domain as text ) & ¬
                \"com.focusbear.latenomore:icon.png\" ¬
            ) ¬
        )
        set buttonReturned to result\'s button returned
        return buttonReturned
    on error errMsg
        display dialog "ERROR: " & errMsg
    end try`
    return await exec(SCRIPT)
}

async function askQuestion(question, title, buttons = [], defaultButton) {
    if (!defaultButton) [defaultButton] = [...buttons].reverse()

    const SCRIPT = `
    try    
        set result to ( ¬
            display dialog \"${question}\" ¬
            default answer \"\n\n\n\n\" ¬
            with title \"${title}\" ¬
            buttons { ${stringify(buttons)} } ¬
            default button \"${defaultButton}\" ¬
        )
        set hold to result
        set buttonReturned to button returned of result
        set userInput to text returned of hold
        return { buttonReturned, userInput } 
    on error errMsg
        display dialog "ERROR: " & errMsg
    end try`

    const [buttonReturned, userInput] = await exec(SCRIPT)

    return { buttonReturned, userInput }
}

module.exports = { showDialog, askQuestion }
