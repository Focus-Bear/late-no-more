const { tidyDate } = require('./tidy');

describe('tidyDate', () => {
  it('should parse a valid date string - 2 digit hour', () => {
    const dateString = 'Friday, February 23, 2024 at 12:30:00 PM';
    const expectedDate = new Date('2024-02-23T12:30:00');

    const actualDate = tidyDate(dateString);

    expect(actualDate).toEqual(expectedDate);
  });

  it('should parse a valid date string - 1 digit hour', () => {
    const dateString = 'Friday, February 23, 2024 at 1:00:00 PM';
    const expectedDate = new Date('2024-02-23T02:00:00.000Z');

    const actualDate = tidyDate(dateString);

    expect(actualDate).toEqual(expectedDate);
  });

  it('should parse a valid date string - 1 digit hour', () => {
    const dateString = 'Friday, February 23, 2024 at 2:25:00 PM';
    const expectedDate = new Date('2024-02-23T03:25:00.000Z');

    const actualDate = tidyDate(dateString);

    expect(actualDate).toEqual(expectedDate);
  });

  it('should return undefined for invalid date string', () => {
    const dateString = '2023-01-13T05:30:00.000';
    
      const actualDate = tidyDate(dateString);

      expect(actualDate).toEqual(undefined);
  });
});
