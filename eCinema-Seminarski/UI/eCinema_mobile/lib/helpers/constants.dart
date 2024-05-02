// const apiUrl = String.fromEnvironment('baseUrl',
//     defaultValue: 'http://localhost:5125/api');

const apiUrl =
    String.fromEnvironment('baseUrl', defaultValue: 'http://10.0.2.2:5125/api');

const stripePublishKey = String.fromEnvironment('stripePublishKey',
    defaultValue:
        'pk_test_51P9X94Ar4z3NmmaxBIbLmvFYSFWtWsT3d622YTgGm8H2tVCrs5EGFa2AUGpHYTA9rstagIRslCF2OqhmUusuQOJh0056qG4M6W');
const stripeSecretKey = String.fromEnvironment('stripeSecretKey',
    defaultValue:
        'sk_test_51P9X94Ar4z3NmmaxOtlZCdd8TT93TfzYxDh4oEme92GZyGZnKg06DZvspsKs84leJDlM8VzVXpaymHyGibV3yoXX00hFCoCBwz');

const appTitle = 'eCinema';
