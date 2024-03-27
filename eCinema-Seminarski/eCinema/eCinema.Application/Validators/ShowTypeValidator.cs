using eCinema.Core;
using FluentValidation;

namespace eCinema.Application.Validators
{
    public class ShowTypeValidator : AbstractValidator<ShowTypeUpsertDto>
    {
        public ShowTypeValidator()
        {
            RuleFor(c => c.Name).NotNull().WithErrorCode(ErrorCodes.NotEmpty);
        }
    }
}
