const fs = require('fs')
const path = require('path')
const csv = require('csv-parser')

const csvPath = '~/Documents/LateNoMore-Meetings.csv'

async function save(filePath, data) {
    try {
        await fs.writeFileSync(filePath, data, {flag: "w"})
    } catch (err) {
        console.error(`Error: Unable to save ${filePath}`)
    }
}

async function ensure(filePath) {
    try {
        const file = fs.readFileSync(filePath, {flag:'r'})
        console.log(`${filePath} opened successfully`)
        return file
    } catch (err) {
        console.error(`Error: ${filePath} does not exist`)
        await save(filePath, '')
        return ensure(filePath)
    }
}

async function parse(file) {
    const asString = file.toString(),
        rows = await csv.parse(asString, (err, rows) => {
            if (err) {
                console.log(err)
            } else {
                data.push(...rows)
                console.log(`${filePath} parsed successfully`)
                return data
            }
        })
}

async function update(row) {
    const records = await ensure(csvPath)

    if (!records.length)
        for (let record of records) {
            const { date, summary } = record

            if (date !== row.date) continue
            if (summary !== row.summary) continue

            for (const key in row) {
                const value = row[key]
                record = { ...record, [key]: value }
            }
        }

    await save(csvPath, records)
}

module.exports = { save, ensure, parse, update }
