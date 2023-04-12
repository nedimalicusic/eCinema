using FluentValidation;
using eCinema.Core;

namespace eCinema.Application
{
    public class CinemaValidator: AbstractValidator<CinemaUpsertDto>
    {
        public CinemaValidator()
        {
            RuleFor(c => c.Name).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Description).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Address).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.Email).NotEmpty().WithErrorCode(ErrorCodes.NotEmpty);
            RuleFor(c => c.PhoneNumber).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.NumberOfSeats).NotNull().WithErrorCode(ErrorCodes.NotNull);
            RuleFor(c => c.CityId).NotNull().WithErrorCode(ErrorCodes.NotNull);
        }
    }
}
