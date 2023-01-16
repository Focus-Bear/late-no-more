const exec = require('./exec.js')

function renderButtons(buttons) {
    let buttonIndex = 1,
        buttonDefs = [],
        buttonRefs = []

    for (const btn of buttons) {
        const name = `button${buttonIndex}Label`,
            definition = `set ${name} to "${btn}"`

        buttonDefs.push(definition)
        buttonRefs.push(name)

        buttonIndex += 1
    }
    return {
        defs: buttonDefs.join('\n'),
        refs: buttonRefs.join(', '),
    }
}

async function showDialog(title, text, buttons, givingUpAfter = 30) {
    const btns = renderButtons(buttons)

    const SCRIPT = ` 

    ${btns.defs}
    set result to ¬ 
        (display dialog "${text}" ¬ 
        with title "${title}" ¬
        buttons { ${btns.refs} } ¬
        default button button1Label ¬ 
        giving up after ${givingUpAfter} ¬
        with icon alias ¬
            ((path to application support from user domain as text) & "com.focusbear.latenomore:icon.png"))
    set buttonReturned to result's button returned
    return buttonReturned`

    return await exec(SCRIPT)
}

async function askQuestion(question, title, buttons, defaultButton) {
    const btns = renderButtons(buttons)

    if (!defaultButton) defaultButton = buttons[0]

    buttons = buttons.map(b=> `"${b}"`).join(", ")
    const SCRIPT = `

  --  try    
        set result to ¬
            (display dialog "${question}"¬
            default answer "" ¬
            with title "${title}" ¬
            buttons { ${buttons} }  ¬
            default button "${defaultButton}")
        set hold to result
        set buttonReturned to button returned of result
        set userInput to text returned of hold
        return {buttonReturned, userInput}
 --   end try`

    const [buttonReturned, userInput] = await exec(SCRIPT)
    return { buttonReturned, userInput }
}
module.exports = { showDialog, askQuestion }
