using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class CountryValidator : AbstractValidator<CountryUpsertDto>
    {
        public CountryValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Abbreviation).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.IsActive).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
