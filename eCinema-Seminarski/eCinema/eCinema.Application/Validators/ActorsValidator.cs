using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ActorsValidator : AbstractValidator<ActorsUpsertDto>
    {
        public ActorsValidator()
        {
            RuleFor(c => c.FirstName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.LastName).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Email).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.BirthDate).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.Gender).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
