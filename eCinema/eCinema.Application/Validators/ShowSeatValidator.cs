using eCinema.Core;
using FluentValidation;

namespace eCinema.Application
{
    public class ShowSeatValidator : AbstractValidator<ShowSeatUpsertDto>
    {
        public ShowSeatValidator()
        {
            RuleFor(c => c.isReserved).NotNull();
            RuleFor(c => c.isSelected).NotNull();
            RuleFor(c => c.isAvailable).NotNull();
            RuleFor(c => c.ShowId).NotNull();
            RuleFor(c => c.SeatId).NotNull();
        }
    }
}
