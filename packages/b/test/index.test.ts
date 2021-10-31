import {handler} from "../src/index";


test('returns success', async () => {
    expect(await handler(null)).toEqual({
        statusCode: 200,
        body: "Greetings: Hello World"
    });
});
