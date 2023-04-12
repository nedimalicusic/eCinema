using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class CityValidator : AbstractValidator<CityUpsertDto>
    {
        public CityValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.ZipCode).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.IsActive).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.CountryId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
