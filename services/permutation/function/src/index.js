import Joi from 'joi';
import permutation from './services/permutation.js';

const schema = Joi.object({ value: Joi.string().min(1).max(8).required() });

const permutationService = permutation({});

export const handler = async (event) => {
  try {
    const body = JSON.parse(event.body);
    const { error } = schema.validate();

    if (error) {
      return { statusCode: 400, body: { message: error.message } };
    }
    const perms = permutationService.calc(body.value);
    const response = {
      statusCode: 200,
      body: JSON.stringify(perms),
    };
    return response;
  } catch (err) {
    console.log('index:handler:err: ', err);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: 'Something went wrong' }),
    };
  }
};
