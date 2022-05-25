def lambda_handler(event=None, context=None):
    print(event)
    return {
        'statusCode' : 200,
        'body' : 'Hello world!'
    }