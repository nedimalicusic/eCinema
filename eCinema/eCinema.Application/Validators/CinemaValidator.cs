using FluentValidation;
using eCinema.Core;

namespace eCinema.Application
{
    public class CinemaValidator: AbstractValidator<CinemaUpsertDto>
    {
        public CinemaValidator()
        {
            RuleFor(c => c.Name).NotEmpty().NotNull();
            RuleFor(c => c.Description).NotEmpty().NotNull();
            RuleFor(c => c.Address).NotEmpty().NotNull();
            RuleFor(c => c.Email).NotEmpty().NotNull();
            RuleFor(c => c.PhoneNumber).NotNull();
            RuleFor(c => c.NumberOfSeats).NotNull();
            RuleFor(c => c.CityId).NotNull();
        }
    }
}
