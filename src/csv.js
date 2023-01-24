const fs = require('fs')
const path = require('path')
const { stringify, parse } = require('../lib/csv/sync.cjs')
const home = require('os').homedir()

const csvPath = home + '/Documents/LateNoMore-Meetings.csv'

async function ensure() {
    try {
        const raw = fs.readFileSync(csvPath),
            data = parse(raw, {
                columns: [
                    'date',
                    'id',
                    'summary',
                    'intention',
                    'notes',
                    'success',
                ],
            })
        if (!data.length) throw "fix"
        return data.slice(1)
    } catch (e) {
        fs.writeFileSync(csvPath, '', { flag: 'w' })
        await save([])
        return []
    }
}

async function save(data) {
    try {
        const asString = stringify(data, {
            header: true,
            columns: ['date', 'id', 'summary', 'intention', 'notes', 'success'],
            cast: { date: (d) => d.toISOString() },
        })

        fs.writeFileSync(csvPath, asString, { flag: 'w' })
        console.log('Saved', csvPath)
    } catch (e) {
        console.log(e)
    }
}
async function remove(evt) {
    try {
        const records = await ensure(),
            trimmed = records.filter(({ id }) => id !== evt.id)
        await save(trimmed)
    } catch (e) {
        console.log(e)
    }
}

async function update(row) {
    const records = await ensure(csvPath)
    if (!records?.length) {
        await save([row])
        return
    }

    let edited = false

    const final = records.map((r) => {
        if (row.id !== r.id) return r
        const updated = { ...r }
        for (const key in row) {
            const value = row[key]
            updated[key] = value
        }
        edited = true
        return updated
    })
    if (!edited) {
        console.log('Adding row to csv..')
        await save([...final, row])
        return
    }

    await save(final)
}

module.exports = { save, ensure, parse, update, remove }
